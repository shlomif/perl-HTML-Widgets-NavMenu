#!/usr/bin/perl -w

use utf8;

package Shlomif::NavMenu;

our $VERSION = '0.1.9';

package Shlomif::NavMenu::Error;

use strict;

use Error qw(:try);

use base "Error";

package Shlomif::NavMenu::Error::Redirect;

use strict;
use vars qw(@ISA);
@ISA=("Shlomif::NavMenu::Error");

sub CGIpm_perform_redirect
{
    my $self = shift;

    my $q = shift;

    print $q->redirect($q->script_name() . $self->{-redirect_path});
    exit;
}

package Shlomif::NavMenu::LeadingPath::Component;

use strict;

use base qw(Shlomif::NavMenu::Object);
use base qw(Class::Accessor);

Shlomif::NavMenu::LeadingPath::Component->mk_accessors(
    qw(host host_url title label direct_url)
    );

sub initialize
{
    my $self = shift;

    my %args = (@_);

    while (my ($k, $v) = each(%args))
    {
        $self->set($k,$v);
    }
    
    return 0;
}

1;

package Shlomif::NavMenu;

use strict;

use lib ".";
use Shlomif::NavMenu::Url;
use Error qw(:try);

require Shlomif::NavMenu::Iterator::NavMenu;
require Shlomif::NavMenu::Iterator::SiteMap;

sub new
{
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->initialize(@_);
    return $self;
}

sub initialize
{
    my $self = shift;

    my %args = (@_);

    $self->_register_path_info(\%args);

    $self->{hosts} = $args{hosts};
    $self->{tree_contents} = $args{tree_contents};

    $self->{current_coords} = [];

    my $current_host = $args{current_host} || "";

    $self->{current_host} = $current_host;

    return 0;
}

sub get_current_coords
{
    my $self = shift;

    return [ @{$self->{current_coords}} ];
}

sub _register_path_info
{
    my $self = shift;
    my $args = shift;

    my $path_info = $args->{path_info};

    my $redir_path = undef;

    if ($path_info eq "")
    {
        $redir_path = "";
    }
    elsif ($path_info =~ m/\/\/$/)
    {
        my $path = $path_info;
        $path =~ s{\/+$}{};
        $redir_path = $path;
    }

    if (defined($redir_path))
    {
        throw Shlomif::NavMenu::Error::Redirect
            -redirect_path => ($redir_path."/");
    }

    $path_info =~ s!^\/!!;

    $self->{path_info} = $path_info;

    return 0;
}

sub is_slash_terminated
{
    my $string = shift;
    return (($string =~ /\/$/) ? 1 : 0);
}

sub text_to_url_obj
{
    my $text = shift;
    my $url = 
        Shlomif::NavMenu::Url->new(
            $text,
            (is_slash_terminated($text) || ($text eq "")),
            "server",
        );
    return $url;
}

sub get_relative_url
{
    my $from_text = shift;
    my $to_text = shift(@_);

    my $from_url = text_to_url_obj($from_text);
    my $to_url = text_to_url_obj($to_text);
    my $ret = 
        $from_url->get_relative_url(
            $to_url, 
            is_slash_terminated($from_text)
        );
   return $ret;
}

sub path_info
{
    my $self = shift;
    return $self->{path_info};
}

sub get_cross_host_rel_url
{
    my $self = shift;
    my %args = (@_);
    my $host = $args{host};
    my $host_url = $args{host_url};
    my $abs_url = $args{abs_url};

    if ($abs_url)
    {
        return $host_url;
    }

    return
        ($host eq $self->{current_host}) ?
            get_relative_url(
                $self->path_info(),
                $host_url
            ) :
            ($self->{hosts}->{$host}->{base_url} . $host_url);
}

sub render_tree_contents
{
    my $self = shift;
    my $path_info = $self->path_info();

    my %args = (@_);

    my $sub_contents = $args{sub_contents};
    my $coords = $args{coords};
    my $host = $sub_contents->{host} || $args{host} or
        die "Host not specified!";
    my $show_always = $args{show_always};
    my $role = $sub_contents->{role} || "normal";

    my @args;
    my $is_separator = 0;

    if ($sub_contents->{separator})
    {
        $is_separator = 1;
    }
    if (exists($sub_contents->{value}))
    {
        push @args, 'value' => $sub_contents->{value};
    }
    if (exists($sub_contents->{show_always}))
    {
        $show_always = $sub_contents->{show_always};
    }
    if (exists($sub_contents->{'host'}))
    {
        push @args, 'host' => $sub_contents->{'host'};
    }
    
    my $is_same_node = 0;
    my $is_hidden = 0;
            
    if (exists($sub_contents->{url}))
    {
        my $host_url = $sub_contents->{url};

        push @args, 
            'url' => $host_url;

        if ($sub_contents->{hide})
        {
            $is_hidden = 1;
        }

        if (($host_url eq $path_info) && ($host eq $self->{current_host}))
        {
            $is_same_node = 1;
        }
    }
    my $new_item;
    {
        $new_item = +{@args};
        if ($is_separator)
        {
            $new_item->{separator} = 1;
        }
        if ($is_hidden)
        {
            $new_item->{hide} = 1;
        }
        if (defined($show_always))
        {
            $new_item->{'show_always'} = $show_always;
        }
        if (defined($role))
        {
            $new_item->{'role'} = $role;
        }
    }
    if (exists($sub_contents->{'title'}))
    {
        $new_item->{'title'} = $sub_contents->{'title'};
    }

    if (exists($sub_contents->{expand_re}))
    {
        my $regexp = $sub_contents->{expand_re};
        # If $regexp is empty - then always succeeed.
        # This is because a pattern match in which the pattern
        # evaluates to an empty regexp uses the last successful pattern
        # match.
        if (($regexp eq "") || ($path_info =~ /$regexp/))
        {
            $new_item->{'Active'} = 1;
        }
    }
    
    $sub_contents->{perl_ref} = $new_item;
    if (exists($sub_contents->{subs}))
    {
        my $index = 0;
        my $subs = [];
        foreach my $sub_contents_sub (@{$sub_contents->{subs}})
        {
            my $sub_item = 
            $self->render_tree_contents(
                'sub_contents' => $sub_contents_sub,
                'coords' => [@$coords, $index],
                'host' => $host,
                'show_always' => $show_always,
            );
            if ($sub_item->{'Active'})
            {
                $new_item->{'Active'}  = 1;
            }
            push @$subs, $sub_item;
        }
        continue
        {
            $index++;
        }
        $new_item->{'subs'} = $subs;
    }
    if ($is_same_node)
    {
        $self->{current_coords} = [ @$coords ];
        $new_item->{'Active'} = 1;
        $new_item->{'CurrentlyActive'} = 1;
    }
    return $new_item;
}



sub gen_site_map
{
    my $self = shift;

    my $iterator = 
        Shlomif::NavMenu::Iterator::SiteMap->new(
            'nav_menu' => $self,
        );

    $iterator->traverse();

    return $iterator->get_results();
}

sub get_next_coords
{
    my $self = shift;

    my @coords = @{shift || $self->get_current_coords};

    my @branches = ($self->{tree_contents});

    my @dest_coords;

    my $i;

    for($i=0;$i<scalar(@coords);$i++)
    {
        $branches[$i+1] = $branches[$i]->{'subs'}->[$coords[$i]];
    }

    if (exists($branches[$i]->{'subs'}))
    {
        @dest_coords = (@coords,0);
    }
    else
    {
        for($i--;$i>=0;$i--)
        {
            if (scalar(@{$branches[$i]->{'subs'}}) > ($coords[$i]+1))
            {
                @dest_coords = (@coords[0 .. ($i-1)], $coords[$i]+1);
                last;
            }
        }
        if ($i == -1)
        {
            return undef;
        }
    }

    return \@dest_coords;
}

sub get_prev_coords
{
    my $self = shift;

    my @coords = @{shift || $self->get_current_coords()};

    if (scalar(@coords) == 0)
    {
        return undef;
    }    
    elsif ($coords[$#coords] > 0)
    {
        # Get the previous leaf
	    my @previous_leaf = 
	        ( 
                @coords[0 .. ($#coords - 1) ] ,
                $coords[$#coords]-1
            );
        # Continue in this leaf to the end.
        my $new_coords = $self->get_most_advanced_leaf(\@previous_leaf);

        return $new_coords;
    }
    elsif (scalar(@coords) > 0)
    {
        return [ @coords[0 .. ($#coords-1)] ];
    }
    else
    {
        return undef;
    }
}

sub get_up_coords
{
    my $self = shift;

    my @coords = @{shift || $self->get_current_coords};

    if (scalar(@coords) == 0)
    {
        return undef;
    }
    else
    {
        if ((@coords == 1) && ($coords[0] > 0))
        {
            return [0];
        }
        pop(@coords);
        return \@coords;
    }
}

sub get_top_coords
{
    my $self = shift;

    my @coords = @{shift || $self->get_current_coords()};

    if ((! @coords) || ((@coords == 1) && ($coords[0] == 0)))
    {
        return undef;
    }
    else
    {
        return [0];
    }
}

sub find_node_by_coords
{
    my $self = shift;
    my $coords = shift;
    my $callback = shift || (sub { });
    my $ptr = $self->{tree_contents};
    my $host = $ptr->{host};
    my $idx = 0;
    my $internal_callback = sub {
        $callback->('idx' => $idx, 'ptr' => $ptr, 'host' => $host);
    };
    $internal_callback->();
    foreach my $c (@$coords)
    {
        $ptr = $ptr->{subs}->[$c];
        $idx++;
        if ($ptr->{host})
        {
            $host = $ptr->{host};
        }
        $internal_callback->();
    }
    return { 'ptr' => $ptr, 'host' => $host };
}

sub is_skip
{
    my $self = shift;
    my $coords = shift;

    my $ret = $self->find_node_by_coords($coords);

    my $ptr = $ret->{ptr};

    return $ptr->{skip};
}

sub get_coords_while_skipping_skips
{
    my $self = shift;

    my $callback = shift;
    my $coords = shift || $self->get_current_coords();
    
    my $do_once = 1;

    while ($do_once || $self->is_skip($coords))
    {
        $coords = $callback->($self, $coords);
    }
    continue
    {
        $do_once = 0;
    }

    return $coords;
}

sub get_most_advanced_leaf
{
    my $self = shift;

    # We accept as a parameter the vector of coordinates
    my $coords_ref = shift;

    my @coords = @{$coords_ref};

    # Get a reference to the contents HDS (= hierarchial data structure)
    my $branch = $self->{tree_contents};

    # Get to the current branch by advancing to the offset 
    foreach my $c (@coords)
    {
        # Advance to the next level which is at index $c
        $branch = $branch->{'subs'}->[$c];
    }

    # As long as there is something deeper
    while (exists($branch->{'subs'}))
    {
        # Get the index of the most advanced sub-branch
        my $index = scalar(@{$branch->{'subs'}})-1;
        # We are going to return it, so store it
        push @coords, $index;
        # Recurse into the sub-branch
        $branch = $branch->{'subs'}->[$index];
    }
    
    return \@coords;
}

sub get_rel_url_from_coords
{
    my $self = shift;
    my $coords = shift;

    my ($ptr,$host);
    my $node_ret = $self->find_node_by_coords($coords);
    $ptr = $node_ret->{ptr};
    $host = $node_ret->{host};

    return $self->get_cross_host_rel_url(
        'host' => $host,
        'host_url' => ($ptr->{url} || ""),
        'abs_url' => $ptr->{abs_url},
    );
}

sub fill_leading_path
{
    my $self = shift;

    my %args = (@_);

    my $coords = $self->get_current_coords();

    # This is so we won't mark the root as CurrentlyActive.
    # Otherwise, the tree is attempted to be captioned and stuff.
    # TODO: add a suitable test.
    if (@$coords)
    {    
        $self->find_node_by_coords($coords, $args{'callback'});
    }
}

sub render
{
    my $self = shift;

    my %args = (@_);

    my $hosts = $self->{hosts};

    my $tree_contents = $self->{tree_contents};

    my $tree = 
        $self->render_tree_contents(
            'sub_tree' => undef, 
            'sub_contents' => $tree_contents, 
            'coords' => [],
            );

    my @current_coords = @{$self->{current_coords}};

    my @leading_path;
    
    if (! @current_coords)
    {
        $tree->{'Active'} = 1;
    }
    {
        my $fill_leading_path_callback =
            sub {
                my %args = (@_);
                my $ptr = $args{ptr};
                my $host = $args{host};
                $host = $ptr->{host} if ($ptr->{host});
                # This is a workaround for the root link.
                my $host_url = $ptr->{url} || "";

                push @leading_path,
                    Shlomif::NavMenu::LeadingPath::Component->new(
                        'host' => $host,
                        'host_url' => $host_url,
                        'title' => $ptr->{title},
                        'label' => $ptr->{value},
                        'direct_url' =>
                            $self->get_cross_host_rel_url(
                                'host' => $host,
                                'host_url' => $host_url,
                                'abs_url' => $ptr->{abs_url},
                            ),
                    );
            };

        $self->fill_leading_path(
            'callback' => $fill_leading_path_callback,
        );
    }

    my %nav_links;

    my %links_proto = 
        (
            'prev' => $self->get_coords_while_skipping_skips(
                        \&get_prev_coords),
            'next' => $self->get_coords_while_skipping_skips(
                        \&get_next_coords),
            'up' => $self->get_up_coords(),
            'top' => $self->get_top_coords(),
        );

    while (my ($link_rel, $coords) = each(%links_proto))
    {
        # This is so we would avoid coordinates that point to the 
        # root ($coords == []).
        if (defined($coords) && @$coords == 0)
        {
            undef($coords);
        }
        if (defined($coords))
        {
            $nav_links{$link_rel} = $self->get_rel_url_from_coords($coords);
        }
    }

    my $iterator = 
        Shlomif::NavMenu::Iterator::NavMenu->new(
            'nav_menu' => $self,
            'tree' => $tree,
        );
    $iterator->traverse();
    my $html = [ @{$iterator->{'html'}} ];
    my $js_code = "";
    
    return 
        {
            'html' => $html,
            'leading_path' => \@leading_path,
            'nav_links' => \%nav_links,
        };
}

1;


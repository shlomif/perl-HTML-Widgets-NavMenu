#!/usr/bin/perl -w

use utf8;

package HTML::Widgets::NavMenu;

our $VERSION = '0.1.12_00';

package HTML::Widgets::NavMenu::Error;

use strict;

use Error qw(:try);

use base "Error";

package HTML::Widgets::NavMenu::Error::Redirect;

use strict;
use vars qw(@ISA);
@ISA=("HTML::Widgets::NavMenu::Error");

sub CGIpm_perform_redirect
{
    my $self = shift;

    my $q = shift;

    print $q->redirect($q->script_name() . $self->{-redirect_path});
    exit;
}

package HTML::Widgets::NavMenu::LeadingPath::Component;

use strict;

use base qw(HTML::Widgets::NavMenu::Object);
use base qw(Class::Accessor);

__PACKAGE__->mk_accessors(
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

package HTML::Widgets::NavMenu;

use strict;

use lib ".";
use HTML::Widgets::NavMenu::Url;
use Error qw(:try);

require HTML::Widgets::NavMenu::Iterator::NavMenu;
require HTML::Widgets::NavMenu::Iterator::SiteMap;
require HTML::Widgets::NavMenu::Tree::Node;

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

    my $current_host = $args{current_host} || "";

    $self->{current_host} = $current_host;

    $self->{'ul_classes'} = ($args{'ul_classes'} || []);

    return 0;
}

sub get_nav_menu_traverser_args
{
    my $self = shift;

    return  ('nav_menu' => $self,
            'ul_classes' => $self->{'ul_classes'});
}

sub get_nav_menu_traverser
{
    my $self = shift;

    return
        HTML::Widgets::NavMenu::Iterator::NavMenu->new(
            $self->get_nav_menu_traverser_args()
        );
}

sub get_current_coords
{
    my $self = shift;

    # This is to make sure $self->{current_coords} is generated.
    $self->get_traversed_tree();

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
        throw HTML::Widgets::NavMenu::Error::Redirect
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
        HTML::Widgets::NavMenu::Url->new(
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

sub gen_blank_nav_menu_tree_node
{
    my $self = shift;

    return HTML::Widgets::NavMenu::Tree::Node->new();
}

sub create_new_nav_menu_item
{
    my $self = shift;
    my %args = (@_);

    my $sub_contents = $args{sub_contents};
    my $coords = $args{coords};
    my $host = $sub_contents->{host} || $args{host} or
        die "Host not specified!";

    my $new_item = $self->gen_blank_nav_menu_tree_node();

    $new_item->set_values_from_hash_ref($sub_contents);

    if (exists($sub_contents->{expand_re}))
    {
        my $regexp = $sub_contents->{expand_re};
        # If $regexp is empty - then always succeeed.
        # This is because a pattern match in which the pattern
        # evaluates to an empty regexp uses the last successful pattern
        # match.
        if (($regexp eq "") || ($self->path_info() =~ /$regexp/))
        {
            $new_item->expand();
        }
    }

    return $new_item;
}

sub render_tree_contents
{
    my $self = shift;

    my %args = (@_);

    my $path_info = $self->path_info();    

    my $sub_contents = $args{sub_contents};
    my $coords = $args{coords};
    my $host = $sub_contents->{host} || $args{host} or
        die "Host not specified!";
    my $current_coords_ptr = $args{current_coords_ptr};

    my $new_item =
        $self->create_new_nav_menu_item(
            %args,
        );

    if (exists($sub_contents->{url}))
    {
        if (($sub_contents->{url} eq $path_info) && ($host eq $self->{current_host}))
        {
            $$current_coords_ptr = [ @$coords ];
            $new_item->mark_as_current();
        }
    }

    if (exists($sub_contents->{subs}))
    {
        my $index = 0;
        my $subs = [];
        foreach my $sub_contents_sub (@{$sub_contents->{subs}})
        {
            $new_item->add_sub(
                $self->render_tree_contents(
                    'sub_contents' => $sub_contents_sub,
                    'coords' => [@$coords, $index],
                    'host' => $host,
                    'current_coords_ptr' => $current_coords_ptr,
                )
            );
        }
        continue
        {
            $index++;
        }
    }
    return $new_item;
}



sub gen_site_map
{
    my $self = shift;

    my $iterator = 
        HTML::Widgets::NavMenu::Iterator::SiteMap->new(
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

    $self->find_node_by_coords($coords, $args{'callback'});
}

# The traversed_tree is the tree that is calculated from the tree given
# by the user and some other parameters such as the host and path_info.
# It is passed to the NavMenu::Iterator::* classes as argument.
sub get_traversed_tree
{
    my $self = shift;

    if (! $self->{'traversed_tree'})
    {
        my $gen_retval = $self->gen_traversed_tree();
        $self->{'traversed_tree'} = $gen_retval->{'tree'};
        $self->{'current_coords'} = $gen_retval->{'current_coords'};
    }
    return $self->{'traversed_tree'};
}

sub gen_traversed_tree
{
    my $self = shift;

    my $current_coords = [];

    my $tree = 
        $self->render_tree_contents(
            'sub_tree' => undef,
            'sub_contents' => $self->{tree_contents},
            'coords' => [],
            'current_coords_ptr' => \$current_coords,
            );

    # The root should always be expanded because:
    # 1. If one of the leafs was marked as expanded so will its ancestors
    #    and eventually the root.
    # 2. If nothing was marked as expanded, it should still be marked as 
    #    expanded so it will expand.
    $tree->expand();
   
    return {'tree' => $tree, 'current_coords' => $current_coords };
}

sub render
{
    my $self = shift;

    my %args = (@_);

    my $iterator = $self->get_nav_menu_traverser();
    $iterator->traverse();
    my $html = [ @{$iterator->{'html'}} ];
    
    my $hosts = $self->{hosts};

    my @leading_path;

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
                    HTML::Widgets::NavMenu::LeadingPath::Component->new(
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

    my $js_code = "";
    
    return 
        {
            'html' => $html,
            'leading_path' => \@leading_path,
            'nav_links' => \%nav_links,
        };
}

=head1 NAME

HTML::Widgets::NavMenu - A Perl Module for Generating HTML Navigation Menus

=head1 SYNOPSIS

    use HTML::Widgets::NavMenu;

    my $nav_menu =
        HTML::Widgets::NavMenu->new(
            'path_info' => "/me/",
            'current_host' => "default",
            'hosts' =>
            {
                'default' =>
                {
                    'base_url' => "http://www.hello.com/"
                },
            },
            'tree_contents' =>
            {
                'host' => "default",
                'value' => "Top 1",
                'title' => "T1 Title",
                'expand_re' => "",
                'subs' =>
                [
                    {
                        'value' => "Home",
                        'url' => "",
                    },
                    {
                        'value' => "About Me",
                        'title' => "About Myself",
                        'url' => "me/",
                    },
                ],
            },
        );

    my $results = $nav_menu->render();

    my $nav_menu_html = join("\n", @{$results->{'html'}});

=head1 DESCRIPTION

This module generates a navigation menu for a site. It can also generate
a complete site map, a path of leading components, and also keeps
track of navigation links ("Next", "Prev", "Up", etc.) It's a little bit 
scarse on documentation now, because it's still was not made ready for
public consumption yet. You can start from the example above and see more
examples in the tests, and complete working sites in the Subversion
repositories at L<http://stalker.iguide.co.il:8080/svn/shlomif-homepage/>
and L<http://opensvn.csie.org/perlbegin/perl-begin/>.

To use this module call the constructor with the following named arguments:

=over 4

=item hosts

This should be a hash reference that maps host-IDs to another hash reference
that contains information about the hosts. An HTML::Widgets::NavMenu navigation
menu can spread across pages in several hosts, which will link from one to
another using relative URLs if possible and fully-qualified (i.e: C<http://>)
URLs if not.

Currently the only key present in the hash is the C<base_url> one that points
to a string containing the absolute URL to the sub-site. The base URL may
have trailing components if it does not reside on the domain's root directory.

Here's an example for a minimal hosts value:

            'hosts' =>
            {
                'default' =>
                {
                    'base_url' => "http://www.hello.com/"
                },
            },

And here's a two-hosts value from my personal site, which is spread across
two sites:

    'hosts' =>
    {
        't2' => 
        {
            'base_url' => "http://www.shlomifish.org/",
        },
        'vipe' =>
        {
            'base_url' => "http://vipe.technion.ac.il/~shlomif/",
        },
    },

=item current_host

This parameter indicate which host-ID of the hosts in C<hosts> is the
one that the page for which the navigation menu should be generated is. This
is important so cross-site and inner-site URLs will be handled correctly.

=item path_info

This is the path relative to the host's C<base_url> of the currently displayed
page. The path should start with a "/"-character, or otherwise a re-direction
excpetion will be thrown (this is done to aid in using this module from within
CGI scripts).

=item tree_contents

This item gives the complete tree for the navigation menu. It is a nested
Perl data structure, whose syntax is fully explained in the section
"The Input Tree of Contents".

=item ul_classes

This is an optional parameter whose value is a reference to an array that 
indicates the values of the class="" arguments for the C<E<lt>ulE<gt>> tags 
whose depthes are the indexes of the array.

For example, assigning:

    'ul_classes' => [ "FirstClass", "second myclass", "3C" ],

Will assign "FirstClass" as the class of the top-most ULs, "second myclass"
as the classes of the ULs inner to it, and "3C" as the class of the ULs inner
to the latter ULs.

If classes are undef, the UL tag will not contain a class parameter.

=back

A complete invocation of an HTML::Widgets::NavMenu constructor can be
found in the SYNOPSIS above.

After you initialize an instance of the navigation menu object, you need to
get the results using the render function.

=head2 $results = $nav_menu->render()

render() should be called after a navigation menu object is constructed
to prepare the results and return them. It returns a hash reference with the
following keys:

=over 4

=item 'html'

This key points to a reference to an array that contains the tags for the 
HTML. One can join these tags to get the full HTML. It is possible to 
delimit them with newlines, if one wishes the markup to be easier to read.

=item 'leading_path'

This is a reference to an array of leading path objects. These indicate the
intermediate pages in the site that lead from the front page to the 
current page. The methods supported by the class of these objects is described
below under "The Leading Path Component Class".

=item 'nav_links'

This points to a hash reference whose keys are Mozilla-style link-toolbar
( L<http://cdn.mozdev.org/linkToolbar/> ) link IDs and its values are the
URLs to these links.

This sample code renders the links as C<E<lt>link rel=...E<gt>> into the
page header:

    my $nav_links = $results->{'nav_links'};
    # Sort the keys so their order will be preserved
    my @keys = (sort { $a cmp $b } keys(%$nav_links));
    foreach my $key (@keys)
    {
        my $url = $nav_links->{$key};
        print {$fh} "<link rel=\"$key\" href=\"" .
            CGI::escapeHTML($url) . "\" />\n";
    }

=back

=head2 $text = $nav_menu->gen_site_map()

This function can be called to generate a site map based on the tree of
contents. It returns a scalar containing all the text of the site map.

=head1 The Input Tree of Contents

FILL IN.

=head1 The Leading Path Component Class

FILL IN.

=head1 SEE ALSO

FILL IN.

=head1 AUTHORS

Shlomi Fish E<lt>shlomif@iglu.org.ilE<gt> 
(L<http://search.cpan.org/~shlomif/>).

=head1 THANKS

Thanks to Yosef Meller (L<http://search.cpan.org/~yosefm/>) for writing
the module HTML::Widget::SideBar on which initial versions of this modules
were based. (albeit his code is no longer used here).

=cut

1;


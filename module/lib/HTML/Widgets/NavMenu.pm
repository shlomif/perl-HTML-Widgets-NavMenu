#!/usr/bin/perl -w

package HTML::Widgets::NavMenu;

our $VERSION = '0.3.1_00';

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
    qw(host host_url title label direct_url url_type)
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
require HTML::Widgets::NavMenu::Predicate;

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

sub current_host
{
    my $self = shift;
    return $self->{'current_host'};
}

sub get_full_abs_url
{
    my $self = shift;
    my %args = (@_);
    my $host = $args{host};
    my $host_url = $args{host_url};
    
    return ($self->{hosts}->{$host}->{base_url} . $host_url);
}

sub get_cross_host_rel_url
{
    my $self = shift;
    my %args = (@_);
    my $host = $args{host};
    my $host_url = $args{host_url};
    my $url_type = $args{url_type};
    my $url_is_abs = $args{url_is_abs};

    if ($url_is_abs)
    {
        return $host_url;
    }
    elsif (($host ne $self->current_host()) || ($url_type eq "full_abs"))
    {
        return $self->get_full_abs_url(@_);
    }
    elsif ($url_type eq "rel")
    {
        return get_relative_url($self->path_info(), $host_url);
    }
    elsif ($url_type eq "site_abs")
    {
        return ($self->{hosts}->{$host}->{trailing_url_base} . $host_url);
    }
    else
    {
        die "Unknown url_type \"$url_type\"!\n";
    }
}

sub get_url_to_item
{
    my $self = shift;
    my (%args) = (@_);
    my $item = $args{'item'};

    return $self->get_cross_host_rel_url(
        'host' => $item->accum_state()->{'host'},
        'host_url' => ($item->node->url() || ""),
        'url_type' => $item->get_url_type(),
        'url_is_abs' => $item->node->url_is_abs(),
    );
}

sub gen_blank_nav_menu_tree_node
{
    my $self = shift;

    return HTML::Widgets::NavMenu::Tree::Node->new();
}

sub create_predicate
{
    my $self = shift;
    my %args = (@_);

    return
        HTML::Widgets::NavMenu::Predicate->new(
            'spec' => $args{'spec'},
        );
}

sub create_new_nav_menu_item
{
    my $self = shift;
    my %args = (@_);

    my $sub_contents = $args{sub_contents};
    my $coords = $args{coords};

    my $new_item = $self->gen_blank_nav_menu_tree_node();

    $new_item->set_values_from_hash_ref($sub_contents);

    if (exists($sub_contents->{'expand'}))
    {
        if ($self->create_predicate(
                'spec' => $sub_contents->{'expand'},
            )->evaluate(
                'path_info' => $self->path_info(),
                'current_host' => $self->current_host(),
            ))
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
        if (($sub_contents->{url} eq $path_info) && ($host eq $self->current_host()))
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

sub is_skip
{
    my $self = shift;
    my $coords = shift;

    my $iterator = $self->get_nav_menu_traverser();

    my $ret = $iterator->find_node_by_coords($coords);

    my $item = $ret->{item};

    return $item->node()->skip();
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
    my $iterator = $self->get_nav_menu_traverser();
    my $node_ret = $iterator->find_node_by_coords($coords);
    my $item = $node_ret->{'item'};

    return $self->get_url_to_item('item' => $item);
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

sub get_leading_path
{
    my $self = shift;
    
    my @leading_path;

    {
        my $iterator = $self->get_nav_menu_traverser(); 
        my $fill_leading_path_callback =
            sub {
                my %args = (@_);
                my $item = $args{item};
                my $iterator = $args{'self'};
                my $node = $item->node();
                # This is a workaround for the root link.
                my $host_url = (defined($node->url()) ? ($node->url()) : "");
                my $host = $item->accum_state()->{'host'};

                my $url_type =
                    ($node->url_is_abs() ?
                        "full_abs" :
                        $item->get_url_type()
                    );

                push @leading_path,
                    HTML::Widgets::NavMenu::LeadingPath::Component->new(
                        'host' => $host,
                        'host_url' => $host_url,
                        'title' => $node->title(),
                        'label' => $node->text(),
                        'direct_url' =>
                            $self->get_url_to_item('item' => $item),
                        'url_type' => $url_type,
                    );
            };

        $iterator->find_node_by_coords(
            $self->get_current_coords(),
            $fill_leading_path_callback,
            );
    }

    return \@leading_path;
}

sub render
{
    my $self = shift;

    my %args = (@_);

    my $iterator = $self->get_nav_menu_traverser();
    $iterator->traverse();
    my $html = $iterator->get_results();
    
    my $hosts = $self->{hosts};

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
            'leading_path' => $self->get_leading_path(),
            'nav_links' => \%nav_links,
        };
}

1;

__END__

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
                'text' => "Top 1",
                'title' => "T1 Title",
                'expand_re' => "",
                'subs' =>
                [
                    {
                        'text' => "Home",
                        'url' => "",
                    },
                    {
                        'text' => "About Me",
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
track of navigation links ("Next", "Prev", "Up", etc.) You can start from the 
example above and see more examples in the tests, and complete working sites 
in the Subversion repositories at 
L<http://stalker.iguide.co.il:8080/svn/shlomif-homepage/>
and L<http://opensvn.csie.org/perlbegin/perl-begin/>.

To use this module call the constructor with the following named arguments:

=over 4

=item hosts

This should be a hash reference that maps host-IDs to another hash reference
that contains information about the hosts. An HTML::Widgets::NavMenu navigation
menu can spread across pages in several hosts, which will link from one to
another using relative URLs if possible and fully-qualified (i.e: C<http://>)
URLs if not.

Currently the only key required in the hash is the C<base_url> one that points
to a string containing the absolute URL to the sub-site. The base URL may
have trailing components if it does not reside on the domain's root directory.

An optional key that is required only if you wish to use the "site_abs" 
url_type (see below), is C<trailing_url_base>, which denotes the component of
the site that appears after the hostname. For C<http://www.myhost.com/~myuser/>
it is C</~myuser/>.

Here's an example for a minimal hosts value:

            'hosts' =>
            {
                'default' =>
                {
                    'base_url' => "http://www.hello.com/",
                    'trailing_url_base' => "/",
                },
            },

And here's a two-hosts value from my personal site, which is spread across
two sites:

    'hosts' =>
    {
        't2' => 
        {
            'base_url' => "http://www.shlomifish.org/",
            'trailing_url_base' => "/",
        },
        'vipe' =>
        {
            'base_url' => "http://vipe.technion.ac.il/~shlomif/",
            'trailing_url_base' => "/~shlomif/",
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
contents. It returns a reference to an array containing the tags of the 
site map.

=head1 The Input Tree of Contents

The input tree is a nested Perl data structure that represnets the tree
of the site. Each node is respresented as a Perl hash reference, with its
sub-nodes contained in an array reference of its C<'subs'> value. A 
non-existent C<'subs'> means that the node is a leaf and has no sub-nodes.

The top-most node is mostly a dummy node, that just serves as the father
of all other nodes.

Following is a listing of the possible values inside a node hash and what
their respective values mean.

=over 4

=item 'host'

This is the host-ID of the host as found in the C<'hosts'> key to the 
navigation menu object constructor. It implicitly propagates downwards in the 
tree. (i.e: all nodes of the sub-tree spanning from the node will implicitly
have it as their value by default.)

Generally, a host must always be specified and so the first node should
specify it.

=item 'url'

This contains the URL of the node within the host. The URL should not
contain a leading slash. This value does not propagate further.

The URL should be specified for every nodes except separators and the such.

=item 'text'

This is the text that will be presented to the user as the text of the 
link inside the navigation bar. E.g.: if C<'text'> is "Hi There", then the
link will look something like this:

    <a href="my-url/">Hi There</a>

Or

    <b>Hi There</b>

if it's the current page. Not that this text is rendered into HTML
as is, and so should be escaped to prevent HTML-injection attacks.

=item 'title'

This is the text of the link tag's title attribute. It is also not
processed and so the user of the module should make sure it is escaped
if needed, to prevent HTML-injection attacks. It is optional, and if not
specified, no title will be presented.

=item 'subs'

This item, if specified, should point to an array reference containing the
sub-nodes of this item, in order.

=item 'separator'

This key if specified and true indicate that the item is a separator, which
should just leave a blank line in the HTML. It is best to accompany it with
C<'skip'> (see below).

If C<'separator'> is specified, it is usually meaningless to specify all 
other node keys except C<'skip'>.

=item 'skip'

This key if true, indicates that the node should be skipped when traversing 
site using the Mozilla navigation links. Instead the navigation will move
to the next or previous nodes.

=item 'hide'

This key if true indicates that the item should be part of the site's flow
and site map, but not displayed in the navigation menu.

=item 'role'

This indicates a role of an item. It is similar to a CSS class, or to 
DocBook's "role" attribute, only induces different HTML markup. The vanilla
HTML::Widgets::NavMenu does not distinguish between any roles, but see
L<HTML::Widgets::NavMenu::HeaderRole>.

=item 'expand'

This specifies a predicate (a Perl value that is evaluated to a boolean
value, see "Predicate Values" below.) to be matched against the path and 
current host to determine if the navigation menu should be expanded at this 
node. If it does, all of the nodes up to it will expand as well.

=item 'show_always'

This value if true, indicates that the node and all nodes below it (until
'show_always' is explicitly set to false) must be always displayed. Its 
function is similar to C<'expand_re'> but its propagation semantics the 
opposite.

=item 'url_type'

This specifies the URL type to use to render this item. It can be:

1. C<"rel"> - the default. This means a fully relative URL (if possible), like
C<"../../me/about.html">.

2. C<"site_abs"> - this uses a URL absolute to the site, using a slash at
the beginning. Like C<"/~shlomif/me/about.html">. For this to work the current
host needs to have a C<'trailing_url_base'> value set.

3. C<"full_abs"> - this uses a fully qualified URL (e.g: with C<http://> at 
the beginning, even if both the current path and the pointed path belong
to the same host. Something like C<http://vipe.technion.ac.il/~shlomif/me/about.html>.

=item 'rec_url_type'

This is similar to C<'url_type'> only it recurses, to the sub-tree of the
node. If both C<'url_type'> and C<'rec_url_type'> are specified for a node,
then the value of C<'url_type'> will hold.

=back

=head1 Predicate Values

An explicitly specified predicate value is a hash reference that contains
one of the following three keys with their appropriate values:

=over 4

=item 'cb' => \&predicate_func

This specifies a sub-routine reference (or "callback" or "cb"), that will be
called to determine the result of the predicate. It accepts two named arguments
- C<'path_info'> which is the path of the current page (without the leading
slash) and C<'current_host'> which is the ID of the current host.

Here is an example for such a callback:

    sub predicate_cb1
    {
        my %args = (@_);
        my $host = $args{'current_host'};
        my $path = $args{'path_info'};
        return (($host eq "true") && ($path eq "mypath/"));
    }

=item 're' => $regexp_string

This specifies a regular expression to be matched against the path_info
(regardless of what current_host is), to determine the result of the 
predicate.

=item 'bool' => [ 0 | 1 ]

This specifies the constant boolean value of the predicate.

=back

Note that if C<'cb'> is specified then both C<'re'> and C<'bool'> will
be ignored, and C<'re'> over-rides C<'bool'>. 

If the predicate is not a hash reference, then HTML::Widgets::NavMenu will
try to guess what it is. If it's a sub-routine reference, it will be an
implicit callback. If it's one of the values C<"0">, C<"1">, C<"yes">, 
C<"no">, C<"true">, C<"false">, C<"True">, C<"False"> it will be considered
a boolean. If it's a different string, a regular expression match will
be attempted. Else, an excpetion will be thrown.

Here are some examples for predicates:

    # Always expand.
    'expand' => { 'bool' => 1, };

    # Never expand.
    'expand' => { 'bool' => 0, };

    # Expand under home/
    'expand' => { 're' => "^home/" },

    # Expand under home/ when the current host is "foo"
    sub expand_path_home_host_foo
    {
        my %args = (@_);
        my $host = $args{'current_host'};
        my $path = $args{'path_info'};
        return (($host eq "foo") && ($path =~ m!^home/!));
    }

    'expand' => { 'cb' => \&expand_path_home_host_foo, },

=head1 The Leading Path Component Class

When retrieving the leading path, an array of objects is returned. This section
describes the class of these objects, so one will know how to use them.

Basically, it is an object that has several accessors. The accessors are:

=over 4

=item host

The host ID of this node.

=item host_url

The URL of the node within the host. (one given in its 'url' key).

=item label

The label of the node. (one given in its 'text' key). This is not
SGML-escaped.

=item title 

The title of the node. (that can be assigned to the URL 'title' attribute).
This is not SGML-escaped.

=item direct_url

A direct URL (usable for inclusion in an A tag ) from the current page to this
page.

=item url_type

This is the C<url_type> (see above) that holds for this node.

=back

=head1 SEE ALSO

=over 4

=item L<HTML::Widgets::NavMenu::HeaderRole>

An HTML::Widgets::NavMenu sub-class that contains support for another 
role. Used for the navigation menu in L<http://perl-begin.berlios.de/>.

=item L<HTML::Widget::SideBar>

A module written by Yosef Meller for maintaining a navigation menu. 
HTML::Widgets::NavMenu originally utilized, but it no longer does. This module
does not makes links relative on its own, and tends to generate a lot of 
JavaScript code by default. It also does not have too many automated test
scripts.

=item L<HTML::Menu::Hierarchical>

A module by Don Owens for generating hierarchical HTML menus. I could not 
quite understand its tree traversal semantics, so I ended up not using it. Also
seems to require that each of the tree node will have a unique ID.

=item L<HTML::Widgets::Menu>

This module also generates a navigation menu. The CPAN version is relatively
old, and the author sent me a newer version. After playing with it a bit, I
realized that I could not get it to do what I want (but I cannot recall
why), so I abandoned it.

=back

=head1 AUTHORS

Shlomi Fish E<lt>shlomif@iglu.org.ilE<gt> 
(L<http://search.cpan.org/~shlomif/>).

=head1 THANKS

Thanks to Yosef Meller (L<http://search.cpan.org/~yosefm/>) for writing
the module HTML::Widget::SideBar on which initial versions of this modules
were based. (albeit his code is no longer used here).

=head1 COPYRIGHT AND LICENSE

Copyright 2004, Shlomi Fish. All rights reserved.

You can use, modify and distribute this module under the terms of the MIT X11
license. ( L<http://www.opensource.org/licenses/mit-license.php> ).

=cut

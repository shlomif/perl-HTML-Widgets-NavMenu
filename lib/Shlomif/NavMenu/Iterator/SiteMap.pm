package Shlomif::NavMenu::Iterator::SiteMap;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Tree::Iterator);

use CGI;

sub initialize
{
    my $self = shift;

    $self->SUPER::initialize(@_);

    my %args = (@_);

    $self->{'nav_menu'} = $args{'nav_menu'} or
        die "nav_menu not specified!";

    $self->{'html'} = [];

    return 0;
}

sub _add_tags
{
    my $self = shift;
    push (@{$self->{'html'}}, @_);
}

sub _is_root
{
    my $self = shift;

    return ($self->_stack_get_num_elems() == 1);
}

sub _get_top_node
{
    my $self = shift;
    return $self->_stack_get_top_item()->{'node'};
}

sub _is_top_separator
{
    my $self = shift;

    return $self->_get_top_node()->{'separator'};
}

sub _get_top_host
{
    my $self = shift;

    return 
        $self->_get_stack_item_accum_state(
            'item' => $self->_stack_get_top_item(),
        )->{'host'};
}

sub get_initial_node
{
    my $self = shift;
    return $self->{'nav_menu'}->{'tree_contents'};
}

sub get_node_subs
{
    my $self = shift;
    my %args = (@_);
    my $node = $args{'node'};
    return
        exists($node->{subs}) ?
            [ @{$node->{subs}} ] :
            [];
}

sub get_new_accum_state
{
    my $self = shift;
    my %args = (@_);
    my $parent_item = $args{'item'};
    my $node = $args{'node'};

    if (!defined($parent_item))
    {
        return { 'host' => $node->{'host'} };
    }

    my $prev_state = 
        $self->_get_stack_item_accum_state('item' => $parent_item);

    return { 'host' => ($node->{'host'} || $prev_state->{'host'}) };
}

sub node_start
{
    my $self = shift;

    my $top_item = $self->_stack_get_top_item();
    my $status = $top_item->{'status'};
    my $node = $self->_get_top_node();

    my $nav_menu = $self->{'nav_menu'};

    if ($self->_is_root())
    {
        $self->_add_tags("<ul>");
    }
    else
    {
        if (!$self->_is_top_separator())
        {
            $self->_add_tags("<li>");
            my $tag = "<a";
            my $title = $node->{'title'};
            $tag .= " href=\"" . 
                CGI::escapeHTML(
                    $nav_menu->get_cross_host_rel_url(
                        'host' => $self->_get_top_host(),
                        'host_url' => $node->{url},
                        'abs_url' => $node->{abs_url},
                    )
                ). "\"";
            if (defined($title))
            {
                $tag .= " title=\"$title\"";
            }
            $tag .= ">" . $node->{value} . "</a>";

            if (defined($title))
            {
                $tag .= " - $title";
            }
            $self->_add_tags($tag);
        }
        if ($self->_are_remaining_subs())
        {
            $self->_add_tags("<br />");
            $self->_add_tags("<ul>");
        }       
    }
}

sub node_end
{
    my $self = shift;

    if ($self->_is_root())
    {
        $self->_add_tags("</ul>");
    }
    else
    {
        if (! $self->_is_top_separator())
        {
            if ($self->_stack_get_top_item()->{'num_subs'})
            {
                $self->_add_tags("</ul>");
            }
            $self->_add_tags("</li>");
        }
    }
}

sub get_results
{
    my $self = shift;

    return join("", map { "$_\n" } @{$self->{'html'}});
}

1;


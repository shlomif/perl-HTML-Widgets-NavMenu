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

    return ($self->stack->len() == 1);
}

sub _is_top_separator
{
    my $self = shift;

    return $self->top->node->{'separator'};
}

sub _get_top_host
{
    my $self = shift;

    return 
        $self->top->accum_state->{'host'};
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
        $parent_item->accum_state();

    return { 'host' => ($node->{'host'} || $prev_state->{'host'}) };
}

sub node_start
{
    my $self = shift;

    my $top_item = $self->top;
    my $node = $self->top->node();

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
        if ($top_item->num_subs_to_go())
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
            if ($self->top()->num_subs())
            {
                $self->_add_tags("</ul>");
            }
            $self->_add_tags("</li>");
        }
    }
}

sub node_should_recurse
{
    return 1;
}

sub get_results
{
    my $self = shift;

    return join("", map { "$_\n" } @{$self->{'html'}});
}

1;


package Shlomif::NavMenu::Iterator::SiteMap;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Iterator::Html);

use CGI;

sub start_root
{
    my $self = shift;
    
    $self->_add_tags("<ul>");
}

sub start_sep
{
}

sub start_regular
{
    my $self = shift;

    my $top_item = $self->top;
    my $node = $self->top->node();

    my $nav_menu = $self->{'nav_menu'};

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

    if ($top_item->num_subs_to_go())
    {
        $self->_add_tags("<br />");
        $self->_add_tags("<ul>");
    }
}

sub end_sep
{
}

sub end_regular
{
    my $self = shift;
    if ($self->top()->num_subs())
    {
        $self->_add_tags("</ul>");
    }
    $self->_add_tags("</li>");
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


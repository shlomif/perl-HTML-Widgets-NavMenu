package Shlomif::NavMenu::Iterator::SiteMap;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Iterator::Base);

use CGI;

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


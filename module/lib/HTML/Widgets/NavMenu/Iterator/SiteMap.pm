package HTML::Widgets::NavMenu::Iterator::SiteMap;

use strict;
use warnings;

use base qw(HTML::Widgets::NavMenu::Iterator::Html);

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
    my $tag = $self->get_a_tag();
    my $title = $node->title();
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

sub is_expanded
{
    return 1;
}

1;

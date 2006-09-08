package HTML::Widgets::NavMenu::Iterator::NavMenu::HeaderRole;

use strict;
use warnings;

use base qw(HTML::Widgets::NavMenu::Iterator::NavMenu);

sub start_handle_role
{
    my $self = shift;
    if ($self->get_role() eq "header")
    {
        $self->_add_tags(
            "</ul>","<h2>", $self->get_link_tag(), "</h2>",
            $self->gen_ul_tag('depth' => $self->stack->len()-1)
            );
    }
    else
    {
        return $self->SUPER::start_handle_role();
    }
}

sub end_handle_role
{
    my $self = shift;
    if ($self->get_role() eq "header")
    {
        # Do nothing;
    }
    else
    {
        return $self->SUPER::end_handle_role();
    }
}

1;


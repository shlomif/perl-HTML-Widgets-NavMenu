package HTML::Widgets::NavMenu::Iterator::NavMenu::HeaderRole;

use strict;
use warnings;

use base qw(HTML::Widgets::NavMenu::Iterator::NavMenu);

=head1 NAME

HTML::Widgets::NavMenu::Iterator::NavMenu::HeaderRole - a nav-menu iterator
for the HeaderRole sub-class.

=head1 OVER-RIDED METHODS

=head2 $iter->_start_handle_role()

Handles the handling the role. Accepts the C<"header"> role and defaults to the
default behaviour with all others.

=cut

sub _start_handle_role
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
        return $self->SUPER::_start_handle_role();
    }
}

=head2 $self->_end_handle_role()

Ends the role. Accepts the C<"header"> role and defaults to the
default behaviour with all others.

=cut 

sub _end_handle_role
{
    my $self = shift;
    if ($self->get_role() eq "header")
    {
        # Do nothing;
    }
    else
    {
        return $self->SUPER::_end_handle_role();
    }
}

=head1 COPYRIGHT & LICENSE

Copyright 2006 Shlomi Fish, all rights reserved.

This program is released under the following license: MIT X11.

=cut

1;


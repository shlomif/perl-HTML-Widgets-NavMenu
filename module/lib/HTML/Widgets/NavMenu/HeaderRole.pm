package HTML::Widgets::NavMenu::HeaderRole;

use strict;

use base 'HTML::Widgets::NavMenu';

require HTML::Widgets::NavMenu::Iterator::NavMenu::HeaderRole;

sub get_nav_menu_traverser
{
    my $self = shift;

    return
        HTML::Widgets::NavMenu::Iterator::NavMenu::HeaderRole->new(
            $self->get_nav_menu_traverser_args()
        );
}

1;


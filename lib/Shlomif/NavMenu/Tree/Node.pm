package Shlomif::NavMenu::Tree::Node;

use base 'Shlomif::NavMenu::Object';

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(
    qw(hide host separator show_always title url value)
    );

1;

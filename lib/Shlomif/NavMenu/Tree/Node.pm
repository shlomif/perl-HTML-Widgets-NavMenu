package Shlomif::NavMenu::Tree::Node;

use base 'Shlomif::NavMenu::Object';

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(
    qw(hide host separator show_always title role url value)
    );

sub initialize
{
    my $self = shift;

    $self->set("role", $self->get_default_role());

    return $self;
}

sub get_default_role
{
    return "normal";
}

1;

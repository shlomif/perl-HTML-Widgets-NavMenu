package Shlomif::NavMenu::Tree::Node;

use base 'Shlomif::NavMenu::Object';

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(
    qw(CurrentlyActive expanded hide host role separator show_always),
    qw(subs title url value)
    );

sub initialize
{
    my $self = shift;

    $self->set("role", $self->get_default_role());

    $self->set("subs", []);

    return $self;
}

sub get_default_role
{
    return "normal";
}

sub expand
{
    my $self = shift;
    $self->expanded(1);
    return 0;
}

sub mark_as_current
{
    my $self = shift;
    $self->expand();
    $self->CurrentlyActive(1);
    return 0;
}

sub _process_new_sub
{
    my $self = shift;
    my $sub = shift;
    if ($sub->expanded())
    {
        $self->expand();
    }
}

sub add_sub
{
    my $self = shift;
    my $sub = shift;
    push (@{$self->subs}, $sub);
    $self->_process_new_sub($sub);
    return 0;
}

1;

package HTML::Widgets::NavMenu::Tree::Node;

use base 'HTML::Widgets::NavMenu::Object';

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(
    qw(CurrentlyActive expanded hide host role rec_url_type),
    qw(separator show_always skip subs text title url url_is_abs url_type),
    );

sub initialize
{
    my $self = shift;

    $self->set("subs", []);

    return $self;
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

sub list_regular_keys
{
    my $self = shift;

    return (qw(host rec_url_type role show_always text title url url_type));
}

sub list_boolean_keys
{
    my $self = shift;

    return (qw(hide separator skip url_is_abs));
}

sub set_values_from_hash_ref
{
    my $self = shift;
    my $sub_contents = shift;

    foreach my $key ($self->list_regular_keys())
    {
        if (exists($sub_contents->{$key}))
        {
            $self->set($key, $sub_contents->{$key});
        }
    }

    foreach my $key ($self->list_boolean_keys())
    {
        if ($sub_contents->{$key})
        {
            $self->set($key, 1);
        }
    }
}

1;

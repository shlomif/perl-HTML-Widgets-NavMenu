package HTML::Widgets::NavMenu::Predicate;

use base 'HTML::Widgets::NavMenu::Object';

use base 'Class::Accessor';

__PACKAGE__->mk_accessors(
    qw(type bool regexp callback),
    );

sub initialize
{
    my $self = shift;

    my %args = (@_);

    my $spec = $args{'spec'};

    $self->_process_spec($spec);

    return 0;
}

my %true_vals = (map { $_ => 1 } (qw(1 yes true True)));

sub is_true_bool
{
    my $self = shift;
    my $val = shift;
    return exists($true_vals{$val});
}

my %false_vals = (map { $_ => 1 } (qw(0 no false False)));

sub is_false_bool
{
    my $self = shift;
    my $val = shift;
    return exists($false_vals{$val});
}

sub _get_normalized_spec
{
    my $self = shift;
    my $spec = shift;

    if (ref($spec) eq "HASH")
    {
        return $spec;
    }
    if (ref($spec) eq "CODE")
    {
        return +{ 'cb' => $spec };
    }
    if ($self->is_true_bool($spec))
    {
        return +{ 'bool' => 1, };
    }
    if ($self->is_false_bool($spec))
    {
        return +{ 'bool' => 0, };
    }
    # Default to regular expression
    if (ref($spec) eq "")
    {
        return +{ 're' => $spec, };
    }
    die "Unknown spec type!";
}

sub _process_spec
{
    my $self = shift;
    my $spec = shift;

    # TODO: Replace me with the real logic.
    $self->_assign_spec(
        $self->_get_normalized_spec(
            $spec,
        ),
    );
}

sub _assign_spec
{
    my $self = shift;
    my $spec = shift;

    if (exists($spec->{'cb'}))
    {
        $self->type("callback");
        $self->callback($spec->{'cb'});

        return 0;
    }
    if (exists($spec->{'re'}))
    {
        $self->type("regexp");
        $self->regexp($spec->{'re'});

        return 0;
    }
    if (exists($spec->{'bool'}))
    {
        $self->type("bool");
        $self->bool($spec->{'bool'});

        return 0;
    }
    die "Neither 'cb' nor 're' nor 'bool' were specified in the spec.";
}

sub evaluate
{
    my $self = shift;

    my (%args) = (@_);

    my $path_info = $args{'path_info'};
    my $current_host = $args{'current_host'};

    my $type = $self->type();

    if ($type eq "callback")
    {
        return $self->callback()->(
            %args
        );
    }
    elsif ($type eq "bool")
    {
        return $self->bool();
    }
    elsif ($type eq "regexp")
    {
        my $re = $self->regexp();
        return (($re eq "") || ($path_info =~ /$re/));
    }
    # We are not supposed to reach this line
    die "Shlomi Fish sucks! Contact him about this";
}

1;


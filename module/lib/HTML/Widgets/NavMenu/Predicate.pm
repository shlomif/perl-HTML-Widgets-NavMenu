package HTML::Widgets::NavMenu::Predicate;

use strict;
use warnings;

use base 'HTML::Widgets::NavMenu::Object';

__PACKAGE__->mk_accessors(
    qw(type bool regexp callback capture),
    );

use HTML::Widgets::NavMenu::ExpandVal;

sub _init
{
    my $self = shift;

    my %args = (@_);

    my $spec = $args{'spec'};

    $self->_process_spec($spec);

    return 0;
}

my %true_vals = (map { $_ => 1 } (qw(1 yes true True)));

sub _is_true_bool
{
    my $self = shift;
    my $val = shift;
    return exists($true_vals{$val});
}

my %false_vals = (map { $_ => 1 } (qw(0 no false False)));

sub _is_false_bool
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
    if ($self->_is_true_bool($spec))
    {
        return +{ 'bool' => 1, };
    }
    if ($self->_is_false_bool($spec))
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
    }
    elsif (exists($spec->{'re'}))
    {
        $self->type("regexp");
        $self->regexp($spec->{'re'});
    }
    elsif (exists($spec->{'bool'}))
    {
        $self->type("bool");
        $self->bool($spec->{'bool'});
    }
    else
    {
        die "Neither 'cb' nor 're' nor 'bool' were specified in the spec.";
    }

    $self->capture(
        (
            (!exists($spec->{capt})) ? 1 : $spec->{capt}
        )
    );
}

sub _evaluate_bool
{
    my ($self, $args) = @_;

    my $path_info = $args->{'path_info'};
    my $current_host = $args->{'current_host'};

    my $type = $self->type();

    if ($type eq "callback")
    {
        return $self->callback()->(
            %$args
        );
    }
    elsif ($type eq "bool")
    {
        return $self->bool();
    }
    else # $type eq "regexp"
    {
        my $re = $self->regexp();
        return (($re eq "") || ($path_info =~ /$re/));
    }
}

sub evaluate
{
    my $self = shift;

    my $bool = $self->_evaluate_bool({@_});

    if (!$bool)
    {
        return $bool;
    }
    else
    {
        return HTML::Widgets::NavMenu::ExpandVal->new(
            capture => $self->capture()
        );
    }
}

=head1 NAME

HTML::Widgets::NavMenu::Predicate - a predicate object for 
HTML::Widgets::NavMenu

=head1 SYNOPSIS

    my $pred = HTML::Widgets::NavMenu::Predicate->new('spec' => $spec);

=head1 FUNCTIONS

=head2 my $pred = HTML::Widgets::NavMenu::Predicate->new('spec' => $spec)

Creates a new object.

=head2 $pred->evaluate( 'path_info' => $path_info, 'current_host' => $current_host )

Evaluates the predicate in the context of C<$path_info> and C<$current_host>
and returns the result.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Shlomi Fish, all rights reserved.

This program is released under the following license: MIT X11.

=cut

1;


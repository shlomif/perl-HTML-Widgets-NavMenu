package Shlomif::NavMenu::Tree::Iterator::Stack;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Object);

sub initialize
{
    my $self = shift;

    $self->{'items'} = [];

    return 0;
}

sub push
{
    my $self = shift;
    my $item = shift;
    push @{$self->{'items'}}, $item;
    return 0;
}

sub len
{
    my $self = shift;
    return scalar(@{$self->{'items'}});
}

sub top
{
    my $self = shift;
    return $self->{'items'}->[-1];
}

sub item
{
    my $self = shift;
    my $index = shift;
    return $self->{'items'}->[$index];
}

sub pop
{
    my $self = shift;
    return pop(@{$self->{'items'}});
}

sub is_empty
{
    my $self = shift;
    return ($self->len() == 0);
}

sub reset
{
    my $self = shift;
    @{$self->{'items'}} = ();
    return 0;
}

1;


package Shlomif::NavMenu::Tree::Iterator::Item;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Object);

sub initialize
{
    my $self = shift;

    my %args = (@_);

    $self->{'node'} = $args{'node'} or
        die "node not specified!";

    my $subs = $args{'subs'} or
        die "subs not specified!";

    $self->{'subs'} = $subs;
    $self->{'sub_idx'} = -1;
    $self->{'visited'} = 0;
    $self->{'accum_state'} = $args{'accum_state'} or
        die "accum_state not specified!";
    
    return 0;
}

sub node
{
    my $self = shift;
    return $self->{'node'};
}

sub accum_state
{
    my $self = shift;
    return $self->{'accum_state'};
}

sub is_visited
{
    my $self = shift;
    return $self->{'visited'};
}

sub visit
{
    my $self = shift;
    $self->{'visited'} = 1;
    if ($self->num_subs_to_go())
    {
        return $self->{'subs'}->[++$self->{'sub_idx'}];
    }
    else
    {
        return undef;
    }
}

sub num_subs_to_go
{
    my $self = shift;
    return $self->num_subs() - $self->{'sub_idx'} - 1;
}

sub num_subs
{
    my $self = shift;
    return scalar(@{$self->{'subs'}});
}

1;


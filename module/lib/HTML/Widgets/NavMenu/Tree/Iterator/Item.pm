package HTML::Widgets::NavMenu::Tree::Iterator::Item;

use strict;
use warnings;

use base qw(HTML::Widgets::NavMenu::Object);

=head1 NAME

HTML::Widgets::NavMenu::Tree::Iterator::Item - an item for the tree iterator.

=head1 SYNOPSIS

For internal use only.

=cut

sub _init
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

sub _node
{
    my $self = shift;
    return $self->{'node'};
}

sub _accum_state
{
    my $self = shift;
    return $self->{'accum_state'};
}

sub _is_visited
{
    my $self = shift;
    return $self->{'visited'};
}

sub _visit
{
    my $self = shift;
    $self->{'visited'} = 1;
    if ($self->_num_subs_to_go())
    {
        return $self->{'subs'}->[++$self->{'sub_idx'}];
    }
    else
    {
        return undef;
    }
}

sub _visited_index
{
    my $self = shift;

    return $self->{'sub_idx'};
}

sub _num_subs_to_go
{
    my $self = shift;
    return $self->_num_subs() - $self->{'sub_idx'} - 1;
}

sub _num_subs
{
    my $self = shift;
    return scalar(@{$self->{'subs'}});
}

sub _get_sub
{
    my $self = shift;
    my $sub_num = shift;
    return $self->{'subs'}->[$sub_num];
}

=head1 COPYRIGHT & LICENSE

Copyright 2006 Shlomi Fish, all rights reserved.

This program is released under the following license: MIT X11.

=cut

1;


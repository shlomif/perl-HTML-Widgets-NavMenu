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

1;


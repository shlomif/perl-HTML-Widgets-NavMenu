package Shlomif::NavMenu::Iterator::SiteMap;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Tree::Iterator);

sub _add_tags
{
    my $self = shift;
    push (@{$self->{'html'}}, @_);
}

1;


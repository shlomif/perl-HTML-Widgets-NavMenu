package HTML::Widgets::NavMenu::Iterator::Html::Item;

use strict;
use warnings;

use parent qw(HTML::Widgets::NavMenu::Tree::Iterator::Item);

sub get_url_type
{
    my $item = shift;
    return (   $item->_node()->url_type()
            || $item->_accum_state()->{'rec_url_type'}
            || "rel" );
}

1;

=head1 NAME

HTML::Widgets::NavMenu::Iterator::Html::Item - an iterator item for HTML.

=head1 SYNOPSIS

For internal use only.

=head1 METHODS

=head2 get_url_type

For internal use only.

=cut

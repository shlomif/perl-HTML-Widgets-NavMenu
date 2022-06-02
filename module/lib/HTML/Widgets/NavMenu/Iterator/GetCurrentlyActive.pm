package HTML::Widgets::NavMenu::Iterator::GetCurrentlyActive;

use strict;
use warnings;

use parent 'HTML::Widgets::NavMenu::Iterator::Base';

__PACKAGE__->mk_acc_ref(
    [
        qw(
            _item_found
            _leading_path_coords
            _ret_coords
            _temp_coords
            _tree
        )
    ]
);

sub _init
{
    my $self = shift;
    my $args = shift;

    $self->SUPER::_init($args);

    $self->_tree( $args->{'tree'} );

    $self->_item_found(0);

    return 0;
}

sub get_initial_node
{
    my $self = shift;

    return $self->_tree;
}

sub item_matches
{
    my $self     = shift;
    my $item     = $self->top();
    my $url      = $item->_node()->url();
    my $nav_menu = $self->nav_menu();
    return (   ( $item->_accum_state()->{'host'} eq $nav_menu->current_host() )
            && ( defined($url) && ( $url eq $nav_menu->path_info() ) ) );
}

sub does_item_expand
{
    my $self = shift;
    my $item = $self->top();
    return $item->_node()->capture_expanded();
}

sub node_start
{
    my $self = shift;

    if ( $self->item_matches() )
    {
        my @coords = @{ $self->get_coords() };
        $self->_ret_coords( [@coords] );
        $self->_temp_coords( [ @coords, (-1) ] );
        $self->top()->_node()->mark_as_current();
        $self->_item_found(1);
    }
    elsif ( $self->does_item_expand() )
    {
        my @coords = @{ $self->get_coords() };
        $self->_leading_path_coords( [@coords] );
    }
}

sub node_end
{
    my $self = shift;
    if ( $self->_item_found() )
    {
        # Skip the first node, because the coords refer
        # to the nodes below it.
        my $idx = pop( @{ $self->_temp_coords() } );
        if ( $idx >= 0 )
        {
            my $node = $self->top()->_node();
            $node->update_based_on_sub( $node->get_nth_sub($idx) );
        }
    }
}

sub node_should_recurse
{
    my $self = shift;
    return ( !$self->_item_found() );
}

sub get_final_coords
{
    my $self = shift;

    return $self->_ret_coords();
}

sub _get_leading_path_coords
{
    my $self = shift;

    return ( $self->_ret_coords() || $self->_leading_path_coords() );
}

1;

__END__

=encoding utf8

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 does_item_expand()

B<internal use>

=head2 get_final_coords()

B<internal use>

=head2 get_initial_node()

B<internal use>

=head2 item_matches()

B<internal use>

=head2 node_end()

B<internal use>

=head2 node_should_recurse()

B<internal use>

=head2 node_start()

B<internal use>

=head2

=cut

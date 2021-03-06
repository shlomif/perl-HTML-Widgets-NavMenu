package HTML::Widgets::NavMenu::Tree::Iterator;

use strict;
use warnings;

use parent qw(HTML::Widgets::NavMenu::Object);

use HTML::Widgets::NavMenu::Tree::Iterator::Stack ();
use HTML::Widgets::NavMenu::Tree::Iterator::Item  ();

__PACKAGE__->mk_acc_ref(
    [
        qw(
            coords
            stack
            _top
        )
    ]
);

=head1 NAME

HTML::Widgets::NavMenu::Tree::Iterator - an iterator for HTML.

=head1 SYNOPSIS

For internal use only.

=head1 METHODS

=head2 coords

Internal use.

=head2 stack

Internal use.

=cut

sub _init
{
    my $self = shift;

    $self->stack( HTML::Widgets::NavMenu::Tree::Iterator::Stack->new() );
    $self->{_top} = undef();

    return 0;
}

=head2 $self->top()

Retrieves the stack top item.

=cut

sub top
{
    return shift(@_)->{_top};
}

sub _construct_new_item
{
    my ( $self, $args ) = @_;

    return HTML::Widgets::NavMenu::Tree::Iterator::Item->new($args);
}

=head2 $self->get_new_item({'node' => $node, 'parent_item' => $parent})

Gets the new item.

=cut

sub get_new_item
{
    my ( $self, $args ) = @_;

    my $node        = $args->{'node'};
    my $parent_item = $args->{'parent_item'};

    return $self->_construct_new_item(
        {
            'node'        => $node,
            'subs'        => $self->get_node_subs( { 'node' => $node } ),
            'accum_state' => $self->get_new_accum_state(
                {
                    'item' => $parent_item,
                    'node' => $node,
                }
            ),
        }
    );
}

=head2 $self->traverse()

Traverses the tree.

=cut

sub traverse
{
    my $self   = shift;
    my $_items = $self->stack->_items;

    my $push = sub {
        push @{$_items},
            (
            $self->{_top} = $self->get_new_item(
                {
                    'node'        => shift(@_),
                    'parent_item' => $self->{_top},
                }
            )
            );
    };
    $push->( $self->get_initial_node() );
    $self->{_is_root} = ( scalar(@$_items) == 1 );

    my $co = $self->coords( [] );

MAIN_LOOP: while ( my $top_item = $self->{_top} )
    {
        my $visited = $top_item->_is_visited();

        if ( !$visited )
        {
            $self->node_start();
        }

        my $sub_item = (
              $self->node_should_recurse()
            ? $top_item->_visit()
            : undef
        );

        if ( defined($sub_item) )
        {
            push @$co, $top_item->_visited_index();
            $push->(
                $self->get_node_from_sub(
                    {
                        'item' => $top_item,
                        'sub'  => $sub_item,
                    }
                ),
            );
            $self->{_is_root} = ( scalar(@$_items) == 1 );
            next MAIN_LOOP;
        }
        else
        {
            $self->node_end();
            pop @$_items;
            $self->{_top}     = $_items->[-1];
            $self->{_is_root} = ( scalar(@$_items) == 1 );
            pop @$co;
        }
    }

    return 0;
}

=head2 $self->get_node_from_sub()

This function can be overridden to generate a node from the sub-nodes
returned by get_node_subs() in a different way than the default.

=cut

sub get_node_from_sub
{
    return $_[1]->{'sub'};
}

=head2 $self->find_node_by_coords($coords, $callback)

Finds a node by its coordinations.

=cut

sub find_node_by_coords
{
    my $self     = shift;
    my $coords   = shift;
    my $callback = shift || ( sub { } );

    my $idx  = 0;
    my $item = $self->get_new_item(
        {
            'node' => $self->get_initial_node(),
        }
    );

    my $internal_callback = sub {
        $callback->(
            'idx'  => $idx,
            'item' => $item,
            'self' => $self,
        );
    };

    $internal_callback->();
    foreach my $c (@$coords)
    {
        $item = $self->get_new_item(
            {
                'node' => $self->get_node_from_sub(
                    {
                        'item' => $item,
                        'sub'  => $item->_get_sub($c),
                    }
                ),
                'parent_item' => $item,
            }
        );
        ++$idx;
        $internal_callback->();
    }
    return +{ 'item' => $item, };
}

=head2 $self->get_coords()

Returns the current coordinates of the object.

=cut

sub get_coords
{
    my $self = shift;

    return $self->coords();
}

sub _is_root
{
    my $self = shift;

    return $self->{_is_root};
}

=head1 COPYRIGHT & LICENSE

Copyright 2006 Shlomi Fish, all rights reserved.

This program is released under the following license: MIT X11.

=cut

1;


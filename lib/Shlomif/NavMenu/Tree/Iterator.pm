package Shlomif::NavMenu::Tree::Iterator;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Object);

use Shlomif::NavMenu::Tree::Iterator::Stack;
use Shlomif::NavMenu::Tree::Iterator::Item;

sub initialize
{
    my $self = shift;

    $self->{'stack'} = Shlomif::NavMenu::Tree::Iterator::Stack->new();

    return 0;
}

sub stack
{
    my $self = shift;

    return $self->{'stack'};
}

sub top
{
    my $self = shift;
    return $self->stack()->top();
}

sub push_into_stack
{
    my $self = shift;

    my %args = (@_);
    my $node = $args{'node'};
    my $subs = $self->get_node_subs('node' => $node);
    my $accum_state =
        $self->get_new_accum_state(
            'item' => $self->top(),
            'node' => $node
        );

    my $new_item =
        Shlomif::NavMenu::Tree::Iterator::Item->new(
            'node' => $node,
            'subs' => $subs,
            'accum_state' => $accum_state,
        );

    $self->stack()->push($new_item);
}

sub traverse
{
    my $self = shift;

    $self->push_into_stack('node' => $self->get_initial_node());

    my $top_item;

    MAIN_LOOP: while ($top_item = $self->top())
    {
        my $visited = $top_item->is_visited();

        if (!$visited)
        {
            $self->node_start();
        }

        my $sub_item =
            ($self->node_should_recurse() ?
                $top_item->visit() :
                undef);

        if (defined($sub_item))
        {
            $self->push_into_stack(
                'node' =>
                    $self->get_node_from_sub(
                        'item' => $top_item,
                        'sub' => $sub_item,
                    ),
                );
            next MAIN_LOOP;
        }
        else
        {
            $self->node_end();
            $self->stack->pop();
        }
    }

    return 0;
}

# This function can be overriden to generate a node from the sub-nodes
# returned by get_node_subs() in a different way than the default.
sub get_node_from_sub
{
    my $self = shift;

    my %args = (@_);

    return $args{'sub'};
}

1;


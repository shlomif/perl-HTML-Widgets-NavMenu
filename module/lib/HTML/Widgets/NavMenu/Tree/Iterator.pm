package HTML::Widgets::NavMenu::Tree::Iterator;

use strict;
use warnings;

use base qw(HTML::Widgets::NavMenu::Object);

use HTML::Widgets::NavMenu::Tree::Iterator::Stack;
use HTML::Widgets::NavMenu::Tree::Iterator::Item;

sub initialize
{
    my $self = shift;

    $self->{'stack'} = HTML::Widgets::NavMenu::Tree::Iterator::Stack->new();

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

sub get_new_item
{
    my $self = shift;
    my %args = (@_);

    my $node = $args{'node'};
    my $parent_item = $args{'parent_item'};

    return
        HTML::Widgets::NavMenu::Tree::Iterator::Item->new(
            'node' => $node,
            'subs' => $self->get_node_subs('node' => $node),
            'accum_state' => 
                $self->get_new_accum_state(
                    'item' => $parent_item,
                    'node' => $node,
                ),
        );
}

sub push_into_stack
{
    my $self = shift;

    my %args = (@_);
    my $node = $args{'node'};

    $self->stack()->push(
        $self->get_new_item(
            'node' => $node,
            'parent_item' => $self->top(),
        ),
    );
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

sub find_node_by_coords
{
    my $self = shift;
    my $coords = shift;
    my $callback = shift || (sub { });

    my $idx = 0;
    my $item =
        $self->get_new_item(
            'node' => $self->get_initial_node(),
        );

    my $internal_callback =
        sub {
            $callback->(
                'idx' => $idx,
                'item' => $item,
                'self' => $self,
            );
        };
    
    $internal_callback->();
    foreach my $c (@$coords)
    {
        $item =
            $self->get_new_item(
                'node' =>
                    $self->get_node_from_sub(
                        'item' => $item,
                        'sub' => $item->get_sub($c),
                    ),
                'parent_item' => $item,
            );
        $idx++;
        $internal_callback->();
    }
    return +{ 'item' => $item, 'self' => $self, };
}

1;


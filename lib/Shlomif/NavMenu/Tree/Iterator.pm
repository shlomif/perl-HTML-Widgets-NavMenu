package Shlomif::NavMenu::Tree::Iterator;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Object);

use Shlomif::NavMenu::Tree::Iterator::Stack;

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

sub _stack_is_empty
{
    my $self = shift;

    return ($self->stack->len() == 0);
}

sub _get_top_remaining_subs
{
    my $self = shift;
    return $self->top->{'remaining_subs'};
}

sub _are_remaining_subs
{
    my $self = shift;
    return (@{$self->_get_top_remaining_subs()} > 0);
}

sub _top_extract_next_sub
{
    my $self = shift;
    return shift(@{$self->_get_top_remaining_subs()});
}

sub _get_stack_item_accum_state
{
    my $self = shift;
    my %args = (@_);

    my $item = $args{'item'};

    return $item->{'accum_state'};
}

sub push_into_stack
{
    my $self = shift;

    my %args = (@_);
    my $node = $args{'node'};

    my $record = +{};
    $record->{'node'} = $node;
    my $subs = $self->get_node_subs('node' => $node);
    $record->{'remaining_subs'} = $subs;
    $record->{'num_subs'} = scalar(@$subs);
    $record->{'visited'} = 0;
    $record->{'accum_state'} =
        $self->get_new_accum_state(
            'item' => $self->top(),
            'node' => $node
        );

    $self->stack()->push($record);
}

sub traverse
{
    my $self = shift;

    $self->push_into_stack('node' => $self->get_initial_node());

    MAIN_LOOP: while (! $self->_stack_is_empty())
    {
        my $top_item = $self->top();
        my $visited = $top_item->{'visited'};

        if (!$visited)
        {
            $self->node_start();
        }
        
        $top_item->{'visited'} = 1;
        
        if ($self->_are_remaining_subs())
        {
            $self->push_into_stack(
                'node' => 
                    $self->get_node_from_sub(
                        'item' => $top_item,
                        'sub' => $self->_top_extract_next_sub()
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
# return by get_node_subs() in a different way than the default.
sub get_node_from_sub
{
    my $self = shift;

    my %args = (@_);

    return $args{'sub'};
}

1;


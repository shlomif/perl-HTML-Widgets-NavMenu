package Shlomif::NavMenu::Tree::Iterator;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Object);

sub initialize
{
    my $self = shift;

    $self->{'stack'} = [];

    return 0;
}

sub _get_stack
{
    my $self = shift;

    return $self->{'stack'};
}

sub _stack_get_num_elems
{
    my $self = shift;

    return scalar(@{$self->_get_stack()});
}

sub _stack_is_empty
{
    my $self = shift;

    return ($self->_stack_get_num_elems() == 0);
}

sub _stack_get_top_item
{
    my $self = shift;

    my $stack = $self->_get_stack();

    return $stack->[-1];
}

sub _stack_pop
{
    my $self = shift;
    pop(@{$self->_get_stack()});
}

sub _get_top_remaining_subs
{
    my $self = shift;
    return $self->_stack_get_top_item()->{'remaining_subs'};
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

sub push_into_stack
{
    my $self = shift;

    my %args = (@_);
    my $node = $args{'node'};
    my $parent_record = 
        ($self->_stack_is_empty() ? 
            +{} : 
            $self->_stack_get_top_item()
        );
    
    my $record = +{};
    $record->{'node'} = $node;
    my $subs = $self->get_node_subs('node' => $node);
    $record->{'remaining_subs'} = $subs;
    $record->{'num_subs'} = scalar(@$subs);
    $record->{'status'} = 0;
    $record->{'host'} = $node->{host} || $parent_record->{host};

    push @{$self->_get_stack()}, $record;
}

sub traverse
{
    my $self = shift;

    $self->push_into_stack('node' => $self->get_initial_node());

    MAIN_LOOP: while (! $self->_stack_is_empty())
    {
        my $top_item = $self->_stack_get_top_item();
        my $status = $top_item->{'status'};

        if (!$status)
        {
            $self->node_start();
        }
        
        $top_item->{status} = 1;
        
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
            $self->_stack_pop();
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


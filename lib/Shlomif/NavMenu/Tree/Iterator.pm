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
    my $subs = 
        exists($node->{subs}) ? 
            [ @{$node->{subs}} ] : 
            [];
    $record->{'remaining_subs'} = $subs;
    $record->{'num_subs'} = scalar(@$subs);
    $record->{'status'} = 0;
    $record->{'host'} = $node->{host} || $parent_record->{host};

    push @{$self->_get_stack()}, $record;
}

sub traverse
{
    my $self = shift;

    my $nav_menu = shift;

    $self->{'nav_menu'} = $nav_menu;

    $self->push_into_stack('node' => $nav_menu->{'tree_contents'} );

    MAIN_LOOP: while (! $self->_stack_is_empty())
    {
        my $top_item = $self->_stack_get_top_item();
        my $status = $top_item->{'status'};

        my $rem_subs = $top_item->{'remaining_subs'};

        if (!$status)
        {
            $self->node_start();
        }
        
        $top_item->{status} = 1;
        
        if (@$rem_subs)
        {
            my $new_item = shift(@$rem_subs);
            $self->push_into_stack('node' => $new_item);
            next MAIN_LOOP;
        }
        else
        {
            $self->node_end();
            $self->_stack_pop();
        }
    }
    return join("", map { "$_\n" } @{$self->{'html'}});
}


1;


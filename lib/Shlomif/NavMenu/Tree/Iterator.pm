package MyProxy;

use Shlomif::NavMenu::Tree::Iterator::Item;

use strict;
use warnings;

use base 'Shlomif::NavMenu::Object';

use vars qw($AUTOLOAD);

sub initialize
{
    my $self = shift;

    $self->{'**PROXIED**'} = 
        Shlomif::NavMenu::Tree::Iterator::Item->new(
            @_
        );
    
    return 0;
}

sub AUTOLOAD
{
    my $self = shift;
    my $func_name = $AUTOLOAD;
    $func_name =~ s!^MyProxy::!!;
    return $self->{'**PROXIED**'}->$func_name(@_);
}

1;

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
        MyProxy->new(
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

    MAIN_LOOP: while (! $self->_stack_is_empty())
    {
        my $top_item = $self->top();
        my $visited = $top_item->is_visited();

        if (!$visited)
        {
            $self->node_start();
        }

        my $sub_item = $top_item->visit();
        
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


#!/usr/bin/perl -w

use Test::More tests => 24;

use strict;

BEGIN {
use_ok ('Shlomif::NavMenu::Tree::Iterator::Item'); # TEST
}

# Let's test the constructor:
# see if it's throwing exceptions when it should.

sub does_throw_exception
{
    my $args = shift;
    my $new_item;
    eval {
        $new_item = Shlomif::NavMenu::Tree::Iterator::Item->new(
            @$args
            );
    };
    if ($@)
    {
        return (1, undef);
    }
    else
    {
        return (0, $new_item);
    }
}

{
    my @args_components = 
        (
            [ 'node' => +{ 'hello' => 'world', }, ], 
            [ 'subs' => [], ],
            [ 'accum_state' => +{ 'yes' => "sir", }, ],
        );
    # TEST*2*2*2
    for(my $i=0;$i<(2**@args_components);$i++)
    {
        my @args = (map { ($i & (1<<$_)) ? (@{$args_components[$_]}) : () } (0 .. $#args_components));
        my ($exception_thrown, $new_item) = does_throw_exception(\@args);
        if ($i == (2**@args_components)-1)
        {
            ok(((!$exception_thrown) && $new_item), 
                "Checking for constructor success with good arguments");
        }
        else
        {
            ok($exception_thrown, "Checking for constructor failure - No. $i");
        }
    }
}

{
    my $item = 
        Shlomif::NavMenu::Tree::Iterator::Item->new(
            'node' => "Hello",
            'subs' => [],
            'accum_state' => 5,
        );
    
    # TEST
    is ($item->node(), "Hello", "Getting the node()");
}

{
    my $item = 
        Shlomif::NavMenu::Tree::Iterator::Item->new(
            'node' => "Hello",
            'subs' => [],
            'accum_state' => "Foobardom",
        );
    
    # TEST
    is ($item->accum_state(), "Foobardom", "Getting Foobardom");
}

{
    my $item =
        Shlomif::NavMenu::Tree::Iterator::Item->new(
            'node' => "Hello",
            'subs' => ["ONE", "Two", "threE3", "4.0"],
            'accum_state' => 5,
        );
    
    
    ok ((!$item->is_visited()), "Item is not visited at start"); # TEST
    is ($item->visit(), "ONE", "First sub"); # TEST
    ok ($item->is_visited(), "Item is visited after first visit"); # TEST
    is ($item->visit(), "Two", "Second sub"); # TEST
    ok ($item->is_visited(), "Item is visited after second visit"); # TEST
    is ($item->visit(), "threE3", "Third sub"); # TEST
    ok ($item->is_visited(), "Item is visited after third visit"); # TEST
    is ($item->visit(), "4.0", "Fourth sub"); # TEST
    ok ($item->is_visited(), "Item is visited after fourth visit"); # TEST
    ok ((!defined($item->visit())), "No more subs"); # TEST
    ok ($item->is_visited(), "Item is visited after no more subs"); # TEST
    ok ((!defined($item->visit())), "No more subs (2)"); # TEST
    is ($item->node(), "Hello", "item->node() is correct"); # TEST
}

#!/usr/bin/perl -w

use Test::More tests => 10;

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

#!/usr/bin/perl -w

use Test::More tests => 13;

use strict;

BEGIN {
use_ok ('Shlomif::NavMenu::Tree::Iterator::Stack'); # TEST
}

{
    my $stack = Shlomif::NavMenu::Tree::Iterator::Stack->new();
    ok ($stack, "Checking for Object Allocation"); # TEST
    $stack->push("Hello");
    $stack->push("World");
    $stack->push("TamTam");
    is ( $stack->len(), 3, "Checking stack len"); # TEST
    is ( $stack->top(), "TamTam", "Checking top of stack"); # TEST
    is ( $stack->item(2), "TamTam", "Checking Item 2"); # TEST
    is ( $stack->item(1), "World", "Checking Item 1"); # TEST
    is ( $stack->item(0), "Hello", "Checking Item 0"); # TEST
    my $popped_item = $stack->pop();
    is ( $popped_item, "TamTam", "Popped Item"); # TEST
    is ( $stack->len(), 2, "Checking stack len"); # TEST
    # TEST
    is ( $stack->top(), "World", "Checking stack top after pop"); 
    $stack->push("Quatts");
    is ( $stack->len(), 3, "Stack Len"); # TEST
    is ( $stack->top(), "Quatts"); # TEST
    $stack->pop();
    $stack->pop();
    $stack->pop();
    # TEST
    ok ( (! defined($stack->top())), 
        "Checking for top() returning undef on empty stack");
}

#!/usr/bin/perl -w

package MyIter;

use strict;

use base 'Shlomif::NavMenu::Tree::Iterator';

sub initialize
{
    my $self = shift;

    $self->SUPER::initialize(@_);

    my %args = (@_);

    $self->{'data'} = $args{'data'};

    $self->{'results'} = [];

    return 0;
}

sub append
{
    my $self = shift;
    push @{$self->{'results'}}, @_;
    return 0;
}

sub get_initial_node
{
    my $self = shift;
    return $self->{'data'};
}

sub get_node_subs
{
    my $self = shift;
    my %args = (@_);
    my $node = $args{'node'};
    return
        exists($node->{'childs'}) ?
            [ @{$node->{'childs'}} ] :
            [];
}

sub get_new_accum_state
{
    my $self = shift;
    my %args = (@_);
    my $parent_item = $args{'item'};
    my $node = $args{'node'};

    if (!defined($parent_item))
    {
        return $node->{'accum'};
    }

    my $prev_state = 
        $parent_item->accum_state();

    return ($node->{'accum'} || $prev_state);
}

sub node_start
{
    my $self = shift;
    my $top_item = $self->top;
    my $node = $self->top->node();

    $self->append(join("-", "Start", $node->{'id'}, $top_item->accum_state));
}

sub node_end
{
    my $self = shift;
    my $node = $self->top->node();

    $self->append(join("-", "End", $node->{'id'}));
}

sub node_should_recurse
{
    my $self = shift;
    my $node = $self->top->node();
    return $node->{'recurse'};
}

1;

package main;

use Test::More tests => 3;

use strict;

use HTML::Widgets::NavMenu::Test::Util;

sub test_traverse
{
    my ($data, $expected, $test_name) = (@_);
    my $traverser =
        MyIter->new(
            'data' => $data
        );

    $traverser->traverse();

    ok ((compare_string_arrays($traverser->{'results'}, $expected) == 0),
        $test_name);
}

{
    my $data =
        {
            'id' => "A",
            'recurse' => 1,
            'accum' => "one",
            'childs' =>
            [
                {
                    'id' => "B",
                    'accum' => "two",
                },
                {
                    'id' => "C",
                    'recurse' => 1,
                    'childs' =>
                    [
                        {
                            'id' => "FG",
                        },
                    ],
                },
            ],
        };
    my @expected = ("Start-A-one", "Start-B-two", "End-B",
        "Start-C-one", "Start-FG-one", "End-FG", "End-C", "End-A");

    # TEST 
    test_traverse($data, \@expected, "Simple example for testing the Tree traverser.");
}

# This test checks that the should_recurse predicate is honoured.
{
    my $data =
        {
            'id' => "A",
            'recurse' => 1,
            'accum' => "one",
            'childs' =>
            [
                {
                    'id' => "B",
                    'accum' => "two",
                },
                {
                    'id' => "C",
                    'recurse' => 0,
                    'childs' =>
                    [
                        {
                            'id' => "FG",
                        },
                    ],
                },
            ],
        };
    my @expected = ("Start-A-one", "Start-B-two", "End-B",
        "Start-C-one", "End-C", "End-A");

    # TEST 
    test_traverse($data, \@expected, "Example with recurse = 0");
}

{
    my $data =
        {
            'id' => "A",
            'recurse' => 1,
            'accum' => "one",
            'childs' =>
            [
                {
                    'id' => "B",
                    'accum' => "two",
                },
                {
                    'id' => "C",
                    'recurse' => 0,
                    'childs' =>
                    [
                        {
                            'id' => "FG",
                        },
                        {
                            'id' => "E",
                            'recurse' => 0,
                            'childs' =>
                            [
                                {
                                    'id' => "Y",
                                },
                                {
                                    'id' => "Z",
                                },
                            ],
                        },
                    ],
                },
                {
                    'id' => "AGH",
                    'recurse' => 1,
                    'accum' => "three",
                    'childs' =>
                    [
                        {
                            'id' => "MON",
                            'recurse' => 0,
                            'accum' => "four",
                            'childs' =>
                            [
                                {
                                    'id' => "HELLO",
                                    'recurse' => 1,
                                },
                            ],
                        },
                        {
                            'id' => "KOJ",
                            'recurse' => 1,
                        },
                    ],
                }
            ],
        };
    my @expected = ("Start-A-one", "Start-B-two", "End-B",
        "Start-C-one", "End-C", "Start-AGH-three", 
        "Start-MON-four", "End-MON", "Start-KOJ-three", "End-KOJ",
        "End-AGH", "End-A");

    # TEST 
    test_traverse($data, \@expected, "Example with lots of weird combinations");
}

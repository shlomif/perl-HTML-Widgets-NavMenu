#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;

use HTML::Widgets::NavMenu;

use HTML::Widgets::NavMenu::Test::Data;

my $test_data = get_test_data();

{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/resume.html",
        @{$test_data->{'with_skips'}},
    );

    # TEST
    is_deeply ($nav_menu->get_current_coords(), [1, 2], 
        "get_current_coords()");

    # TEST
    is_deeply ($nav_menu->get_next_coords(), [2], 
        "Testing that get_next_coords does _not_ skip skips by default");
    # TEST
    is_deeply ($nav_menu->get_prev_coords(), [1,1], 
        "Testing get_prev_coords");
}

{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/open-source/",
        @{$test_data->{'with_skips'}},
    );

    # TEST
    is_deeply ($nav_menu->get_current_coords(), [3], 
        "get_current_coords()");

    # TEST
    is_deeply ($nav_menu->get_next_coords(), [3,0], 
        "Testing get_next_coords");
    # TEST
    is_deeply ($nav_menu->get_prev_coords(), [2], 
        "Testing get_prev_coords");
}

#!/usr/bin/perl -w

use strict;

use Test::More tests => 3;

use HTML::Widgets::NavMenu;

use HTML::Widgets::NavMenu::Test::Data;

my $test_data = get_test_data();

# This check tests that a leading path with a URL that is not registered
# in the nav menu still has one component of the root.
{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/non-existent-path/",
        @{$test_data->{'minimal'}},
    );

    my $rendered = 
        $nav_menu->render(
            'no_ie' => "true",
            'styles' =>
            {
                'bar' => 'nav',
                'level0' => 'navbarmain',
                'level1' => 'navbarnested',
                'level2' => "navbarnested",
                'level3' => "navbarnested",
                'level4' => "navbarnested",
                'list' => "navbarmain",
            },
        );

    my @leading_path = @{$rendered->{'leading_path'}};

    # TEST
    ok ((scalar(@leading_path) == 1), "Checking for a leading path of len 1");

    my $component = $leading_path[0];

    # TEST
    is ($component->title(), "T1 Title", "Testing for title of leading_path"); 
    
    # TEST
    is ($component->direct_url(), "../", "Testing for direct_url");
}

    


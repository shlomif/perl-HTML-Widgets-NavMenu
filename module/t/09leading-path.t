#!/usr/bin/perl -w

use strict;

use Test::More tests => 13;

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
        $nav_menu->render();

    my @leading_path = @{$rendered->{'leading_path'}};

    # TEST
    ok ((scalar(@leading_path) == 1), "Checking for a leading path of len 1");

    my $component = $leading_path[0];

    # TEST
    is ($component->title(), "T1 Title", "Testing for title of leading_path"); 
    
    # TEST
    is ($component->direct_url(), "../", "Testing for direct_url");
}

# This check tests the url_type behaviour of the leading-path
{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/yowza/howza/",
        @{$test_data->{'rec_url_type_menu'}},
    );

    my $rendered = 
        $nav_menu->render();

    my @leading_path = @{$rendered->{'leading_path'}};

    # TEST
    ok ((scalar(@leading_path) == 3), "Checking for a leading path of len 3");

    my $component = $leading_path[0];

    # TEST
    is ($component->title(), "T1 Title", "Testing for title of leading_path"); 
    
    # TEST
    is ($component->direct_url(), "http://www.hello.com/~shlomif/", 
        "Testing for direct_url");

    # TEST
    is ($component->url_type(), "full_abs", "Testing for url_type");

    $component = $leading_path[1];

    # TEST
    is ($component->label(), "Yowza", "Testing for label of leading_path"); 
    
    # TEST
    is ($component->direct_url(), "../", 
        "Testing for direct_url");

    # TEST
    is ($component->url_type(), "rel", "Testing for url_type");

    $component = $leading_path[2];

    # TEST
    is ($component->label(), "This should be full_abs again", 
        "Testing for label of leading_path"); 
    
    # TEST
    is ($component->direct_url(), "http://www.hello.com/~shlomif/yowza/howza/", 
        "Testing for direct_url");

    # TEST
    is ($component->url_type(), "full_abs", "Testing for url_type");
}

#!/usr/bin/perl -w

use strict;

use Test::More tests => 6;

use HTML::Widgets::NavMenu;

use HTML::Widgets::NavMenu::Test::Data;

my $test_data = get_test_data();

my @site_args = 
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
        'expand_re' => "",
        'subs' =>
        [
            {
                'text' => "Home",
                'url' => "",
            },
            {
                'text' => "About Me",
                'title' => "About Myself",
                'url' => "me/",
            },
            {
                'text' => "Last Page",
                'title' => "Last Page",
                'url' => "last-page.html",
            }
        ],
    },    
);

# The purpose of this test is to check for the in-existence of navigation
# links from the first page. Generally, there shouldn't be "top", "up" and 
# "prev" nav-links and only "next".
{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/",
        @site_args
    );

    my $rendered = $nav_menu->render();

    my $nav_links = $rendered->{'nav_links'};
    
    # TEST
    ok ((scalar(keys(%$nav_links)) == 1) && (exists($nav_links->{'next'})),
        "Lack of Nav-Links in the First Page")
}

# The purpose of this test is to check for up arrow leading from the middle
# page to the "Home" page
{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/me/",
        @site_args
    );

    my $rendered = $nav_menu->render();

    my $nav_links = $rendered->{'nav_links'};

    # TEST
    is($nav_links->{'up'}, "../",
       "Up page leading upwards to the first page.");
    # TEST
    is($nav_links->{'top'}, "../",
       "Top nav-link leading topwards to the first page.");
}

# This tests for behaviour with url_is_abs:
{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/",
        @{$test_data->{'url_is_abs_menu'}},
    );

    my $rendered = $nav_menu->render();

    my $nav_links = $rendered->{'nav_links'};

    # TEST
    is ($nav_links->{'next'}, "http://www.google.com/",
        "Next nav_link in url_is_abs site");
}

{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/sub-dir/",
        @{$test_data->{'url_is_abs_menu'}},
    );

    my $rendered = $nav_menu->render();

    my $nav_links = $rendered->{'nav_links'};

    # TEST
    is ($nav_links->{'up'}, "http://www.google.com/",
        "Up nav_link in url_is_abs site");
    # TEST
    is ($nav_links->{'prev'}, "http://www.google.com/",
        "Prev nav_link in url_is_abs site");
}

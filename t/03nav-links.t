#!/usr/bin/perl -w

use strict;

use Test::More tests => 3;

use HTML::Widgets::NavMenu;

my @site_args = 
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'value' => "Top 1",
        'title' => "T1 Title",
        'expand_re' => "",
        'subs' =>
        [
            {
                'value' => "Home",
                'url' => "",
            },
            {
                'value' => "About Me",
                'title' => "About Myself",
                'url' => "me/",
            },
            {
                'value' => "Last Page",
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

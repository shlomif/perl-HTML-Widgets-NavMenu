#!/usr/bin/perl -w

use strict;

use Test::More tests => 7;

use HTML::Widgets::NavMenu;

{
    my $nav_menu = HTML::Widgets::NavMenu->new(
        'path_info' => "/path1/path2/",
        'current_host' => "shlomif",
        'hosts' => 
        {
            'shlomif' =>
            {
                'base_url' => "http://www.shlomifish.org/",
                'trailing_url_base' => "/",
            },
            'vipe' =>
            {
                'base_url' => "http://vipe.technion.ac.il/~shlomif/",
                'trailing_url_base' => "/~shlomif/",
            },
        },
        # This is just to settle the constructor
        'tree_contents' =>
        {
            'host' => "shlomif",
            'text' => "Top 1",
            'title' => "T1 Title",
        },
    );
    
    # TEST*3
    foreach my $url_type (qw(rel site_abs full_abs))
    {
        is ( 
            $nav_menu->get_cross_host_rel_url(
                'host' => "vipe",
                'host_url' => "hello/",
                'url_type' => $url_type,
            ), "http://vipe.technion.ac.il/~shlomif/hello/",
            "Testing for cross-host URL of $url_type."
        );
    }

    # TEST
    is (
        $nav_menu->get_cross_host_rel_url(
            'host' => "shlomif",
            'host_url' => "hello/",
            'url_type' => "rel",
        ), "../../hello/", 
        "Checking for intra-host link of 'rel'");
    # TEST
    is (
        $nav_menu->get_cross_host_rel_url(
            'host' => "shlomif",
            'host_url' => "hello/",
            'url_type' => "site_abs",
        ), "/hello/", 
        "Checking for intra-host link of 'site_abs'");
    # TEST
    is (
        $nav_menu->get_cross_host_rel_url(
            'host' => "shlomif",
            'host_url' => "hello/",
            'url_type' => "full_abs",
        ), "http://www.shlomifish.org/hello/", 
        "Checking for intra-host link of 'full_abs'");
    # TEST
    eval {
        my $string = $nav_menu->get_cross_host_rel_url(
            'host' => "shlomif",
            'host_url' => "hello/",
            'url_type' => "unknown",
        );
    };
    ok ($@, "Checking for exception thrown on intra-host URL with an unknown url_type");
}


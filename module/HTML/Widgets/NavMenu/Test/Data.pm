package HTML::Widgets::NavMenu::Test::Data;

use strict;

use Exporter;
use vars qw(@ISA);
@ISA=qw(Exporter);

use vars qw(@EXPORT);

@EXPORT = qw(get_test_data);

my @minimal_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
        ],
    },
);

my @two_sites_data =
(
    'current_host' => "default",
    'hosts' =>
    {
        'default' =>
        {
            'base_url' => "http://www.hello.com/",
        },
        'other' => 
        { 
            'base_url' => "http://www.other-url.co.il/~shlomif/", 
        },
    },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'subs' =>
                [
                    {
                        'url' => "round/hello/personal.html",
                        'text' => "Bio",
                        'title' => "Biography of Myself",
                    },
                    {
                        'url' => "round/toto/",
                        'text' => "Gloria",
                        'title' => "A Useful Conspiracy",
                    },
                ],
            },
            {
                'text' => "Tam Tam Drums",
                'title' => "Drumming is good for your health",
                'url' => "hoola/",
                'host' => "other",
                'subs' =>
                [
                    {
                        'url' => "hello/hoop.html",
                        'title' => "Hoola Hoops Rulez and Ownz!",
                        'text' => "Hoola Hoops",
                        'host' => "default",
                    },
                    {
                        'url' => "tetra/",
                        'text' => "Tetrahedron",
                        'subs' =>
                        [
                            {
                                'url' => "tetra/one/",
                                'text' => "Tetra One",
                                'title' => "Tetra One Title",
                            },
                        ],
                    },
                ],
            },
        ],
    },
);

my @expand_re_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'text' => "Foo",
                'title' => "Fooish",
                'url' => "foo/",
                'subs' =>
                [
                    {
                        'text' => "Expanded",
                        'title' => "Expanded",
                        'url' => "foo/expanded/",
                        'expand' => { 're' => "", },
                    },
                ],
            }
        ],
    },
);

my @show_always_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'text' => "Show Always",
                'url' => "show-always/",
                'show_always' => 1,
                'subs' =>
                [
                    {
                        'text' => "Gandalf",
                        'url' => "show-always/gandalf/",
                    },
                    {
                        'text' => "Robin",
                        'url' => "robin/",
                        'subs' =>
                        [
                            {
                                'text' => "Hood",
                                'url' => "robin/hood/",
                            },
                        ],
                    },
                    {
                        'text' => "Queen Esther",
                        'url' => "esther/",
                        'subs' =>
                        [
                            {
                                'text' => "Haman",
                                'url' => "haman/",
                            },
                        ],
                    },
                ],
            },
        ],
    },
);

my @items_in_sub_nav_menu =
(
    'current_host' => "default",
    'hosts' =>
    {
        'default' =>
        {
            'base_url' => "http://www.hello.com/",
        },
    },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'subs' =>
                [
                    {
                        'url' => "me/bio.html",
                        'text' => "Bio",
                        'title' => "Biography of Myself",
                    },
                    {
                        'url' => "me/gloria/",
                        'text' => "Gloria",
                        'title' => "A Useful Conspiracy",
                    },
                ],
            },
            {
                'text' => "Tam Tam Drums",
                'title' => "Drumming is good for your health",
                'url' => "hoola/",
            },
        ],
    },
);

my @separator_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'subs' =>
                [
                    {
                        'text' => "Group Hug",
                        'url' => "me/group-hug/",
                    },
                    {
                        'text' => "Cool I/O",
                        'url' => "me/cool-io/",
                    },
                    {
                        'separator' => 1,
                        'skip' => 1,
                    },
                    {
                        'text' => "Resume",
                        'url' => "resume.html",
                    },
                ],
            },
            {
                'separator' => 1,
                'skip' => 1,
            },
            {
                'text' => "Halifax",
                'url' => "halifax/",
            },
        ],
    },
);

my @hidden_item_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'subs' =>
                [
                    {
                        'text' => "Visible",
                        'url' => "me/visible/",
                    },
                    {
                        'text' => "Hidden",
                        'url' => "me/hidden/",
                        'hide' => 1,
                    },
                    {
                        'text' => "Visible Too",
                        'url' => "me/visible-too/",
                    },
                ],
            },
        ],
    },
);

my @header_role_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'role' => "header",
                'show_always' => 1,
                'subs' =>
                [
                    {
                        'text' => "Sub Me",
                        'url' => "me/sub-me1/",
                    },
                    {
                        'text' => "Sub Me 2",
                        'url' => "me/sub-me-two/",
                    },
                ],
            },
        ],
    },
);

my @selective_expand_nav_menu =
(
    'current_host' => "default",
    'hosts' => { 'default' => { 'base_url' => "http://www.hello.com/" }, },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'expand' => { 're' => "^me/", },
                'subs' =>
                [
                    {
                        'text' => "Group Hug",
                        'url' => "me/group-hug/",
                    },
                    {
                        'text' => "Cool I/O",
                        'url' => "me/cool-io/",
                    },
                    {
                        'text' => "Resume",
                        'url' => "resume.html",
                    },
                ],
            },
            {
                'text' => "Halifax",
                'url' => "halifax/",
            },
            {
                'text' => "Software",
                'title' => "Open Source Software I Wrote",
                'url' => "open-source/",
                'expand' => { 're' => "^open-source/", },
                'subs' =>
                [
                    {
                        'text' => "Fooware",
                        'url' => "open-source/fooware/",
                    },
                    {
                        'text' => "Condor-Man",
                        'title' => "Kwalitee",
                        'url' => "open-source/condor-man/",
                    },
                ],
            },            
        ],
    },
);

my @url_type_menu =
(
    'current_host' => "default",
    'hosts' =>
        { 
        'default' => 
            { 
                'base_url' => "http://www.hello.com/",
                'trailing_url_base' => "/",
            },
        },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
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
                'url_type' => "site_abs",
            },
            {
                'text' => "Yowza",
                'url' => "yowza/",
                'url_type' => "full_abs",
            },
        ],
    },
);

my @rec_url_type_menu =
(
    'current_host' => "default",
    'hosts' =>
        { 
        'default' => 
            { 
                'base_url' => "http://www.hello.com/~shlomif/",
                'trailing_url_base' => "/~shlomif/",
            },
        },
    'tree_contents' =>
    {
        'host' => "default",
        'text' => "Top 1",
        'title' => "T1 Title",
        'rec_url_type' => "full_abs",
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
                'url_type' => "site_abs",
            },
            {
                'text' => "Hoola",
                'url' => "tedious/to/write/",
            },
            {
                'text' => "Yowza",
                'url' => "yowza/",
                'url_type' => "rel",
                'show_always' => 1,
                'subs' =>
                [
                    {
                        'url' => "yowza/howza/",
                        'text' => "This should be full_abs again",
                    },
                ],
            },
        ],
    },
);

sub get_test_data
{
    return
        {
            'two_sites' => \@two_sites_data,
            'minimal' => \@minimal_nav_menu,
            'expand_re' => \@expand_re_nav_menu,
            'show_always' => \@show_always_nav_menu,
            'items_in_sub' => \@items_in_sub_nav_menu,
            'separator' => \@separator_nav_menu,
            'hidden_item' => \@hidden_item_nav_menu,
            'header_role' => \@header_role_nav_menu,
            'selective_expand' => \@selective_expand_nav_menu,
            'url_type_menu' => \@url_type_menu,
            'rec_url_type_menu' => \@rec_url_type_menu,
        };
}

1;

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
                'subs' =>
                [
                    {
                        'url' => "round/hello/personal.html",
                        'value' => "Bio",
                        'title' => "Biography of Myself",
                    },
                    {
                        'url' => "round/toto/",
                        'value' => "Gloria",
                        'title' => "A Useful Conspiracy",
                    },
                ],
            },
            {
                'value' => "Tam Tam Drums",
                'title' => "Drumming is good for your health",
                'url' => "hoola/",
                'host' => "other",
                'subs' =>
                [
                    {
                        'url' => "hello/hoop.html",
                        'title' => "Hoola Hoops Rulez and Ownz!",
                        'value' => "Hoola Hoops",
                        'host' => "default",
                    },
                    {
                        'url' => "tetra/",
                        'value' => "Tetrahedron",
                        'subs' =>
                        [
                            {
                                'url' => "tetra/one/",
                                'value' => "Tetra One",
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
                'value' => "Foo",
                'title' => "Fooish",
                'url' => "foo/",
                'subs' =>
                [
                    {
                        'value' => "Expanded",
                        'title' => "Expanded",
                        'url' => "foo/expanded/",
                        'expand_re' => "",
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
                'value' => "Show Always",
                'url' => "show-always/",
                'show_always' => 1,
                'subs' =>
                [
                    {
                        'value' => "Gandalf",
                        'url' => "show-always/gandalf/",
                    },
                    {
                        'value' => "Robin",
                        'url' => "robin/",
                        'subs' =>
                        [
                            {
                                'value' => "Hood",
                                'url' => "robin/hood/",
                            },
                        ],
                    },
                    {
                        'value' => "Queen Esther",
                        'url' => "esther/",
                        'subs' =>
                        [
                            {
                                'value' => "Haman",
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
                'subs' =>
                [
                    {
                        'url' => "me/bio.html",
                        'value' => "Bio",
                        'title' => "Biography of Myself",
                    },
                    {
                        'url' => "me/gloria/",
                        'value' => "Gloria",
                        'title' => "A Useful Conspiracy",
                    },
                ],
            },
            {
                'value' => "Tam Tam Drums",
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
                'subs' =>
                [
                    {
                        'value' => "Group Hug",
                        'url' => "me/group-hug/",
                    },
                    {
                        'value' => "Cool I/O",
                        'url' => "me/cool-io/",
                    },
                    {
                        'separator' => 1,
                        'skip' => 1,
                    },
                    {
                        'value' => "Resume",
                        'url' => "resume.html",
                    },
                ],
            },
            {
                'separator' => 1,
                'skip' => 1,
            },
            {
                'value' => "Halifax",
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
                'subs' =>
                [
                    {
                        'value' => "Visible",
                        'url' => "me/visible/",
                    },
                    {
                        'value' => "Hidden",
                        'url' => "me/hidden/",
                        'hide' => 1,
                    },
                    {
                        'value' => "Visible Too",
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
                'role' => "header",
                'show_always' => 1,
                'subs' =>
                [
                    {
                        'value' => "Sub Me",
                        'url' => "me/sub-me1/",
                    },
                    {
                        'value' => "Sub Me 2",
                        'url' => "me/sub-me-two/",
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
        };
}

1;

#!/usr/bin/perl -w

use strict;

use Test::More tests => 7;

use Shlomif::NavMenu;

use HTML::Widgets::NavMenu::Test::Data;
use HTML::Widgets::NavMenu::Test::Util;

my $test_data = get_test_data();

sub validate_nav_menu
{
    my $rendered = shift;
    my $expected_string = shift;
    
    my @result = (@{$rendered->{html}});

    my @expected = (split(/\n/, $expected_string));

    return (compare_string_arrays(\@expected, \@result) == 0);
}

{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/hello/",
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="../">Home</a>
</li>
<li>
<a href="../me/" title="About Myself">About Me</a>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string), 
        "Nav Menu for minimal - 1"); 
}


{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/me/",
        @{$test_data->{'two_sites'}},
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="../">Home</a>
</li>
<li>
<b>About Me</b>
<br />
<ul class="navbarnested">
<li>
<a href="../round/hello/personal.html" title="Biography of Myself">Bio</a>
</li>
<li>
<a href="../round/toto/" title="A Useful Conspiracy">Gloria</a>
</li>
</ul>
</li>
<li>
<a href="http://www.other-url.co.il/~shlomif/hoola/" title="Drumming is good for your health">Tam Tam Drums</a>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string), 
        "Nav Menu for minimal - 2"); 
}

# This test tests that an expand_re directive should not cause
# the current coords to be assigned to it, thus marking a site
# incorrectly.
{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/me/",
        @{$test_data->{'expand_re'}},
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="../">Home</a>
</li>
<li>
<b>About Me</b>
</li>
<li>
<a href="../foo/" title="Fooish">Foo</a>
<br />
<ul class="navbarnested">
<li>
<a href="../foo/expanded/" title="Expanded">Expanded</a>
</li>
</ul>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string), 
        "Nav Menu for expand_re"); 
}

# This test tests that an empty expand_re directive works after a successful
# pattern match.
{
    my $string = "aslkdjofisvniowgvnoaifnaoiwfb";
    $string =~ s{ofisvniowgvnoaifnaoiwfb$}{};
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/me/",
        @{$test_data->{'expand_re'}},
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="../">Home</a>
</li>
<li>
<b>About Me</b>
</li>
<li>
<a href="../foo/" title="Fooish">Foo</a>
<br />
<ul class="navbarnested">
<li>
<a href="../foo/expanded/" title="Expanded">Expanded</a>
</li>
</ul>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string),
        "Nav Menu for empty expand_re after successful pattern match");
}

# This test tests the show_always directive which causes the entire
# sub-tree to expand at any URL.
{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/me/",
        @{$test_data->{'show_always'}},
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="../">Home</a>
</li>
<li>
<b>About Me</b>
</li>
<li>
<a href="../show-always/">Show Always</a>
<br />
<ul class="navbarnested">
<li>
<a href="../show-always/gandalf/">Gandalf</a>
</li>
<li>
<a href="../robin/">Robin</a>
<br />
<ul class="navbarnested">
<li>
<a href="../robin/hood/">Hood</a>
</li>
</ul>
</li>
<li>
<a href="../esther/">Queen Esther</a>
<br />
<ul class="navbarnested">
<li>
<a href="../haman/">Haman</a>
</li>
</ul>
</li>
</ul>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string),
        "Nav Menu with show_always");
}

# This test tests a menu auto-expands if the current URL is an item
# inside it.
{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/me/bio.html",
        @{$test_data->{'items_in_sub'}},
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="./../">Home</a>
</li>
<li>
<a href="./" title="About Myself">About Me</a>
<br />
<ul class="navbarnested">
<li>
<b>Bio</b>
</li>
<li>
<a href="./gloria/" title="A Useful Conspiracy">Gloria</a>
</li>
</ul>
</li>
<li>
<a href="./../hoola/" title="Drumming is good for your health">Tam Tam Drums</a>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string),
        "Nav Menu with a selected sub-item");
}

{
    my $nav_menu = Shlomif::NavMenu->new(
        'path_info' => "/me/",
        @{$test_data->{'separator'}},
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

    my $expected_string = <<"EOF";
<ul class="navbarmain">
<li>
<a href="../">Home</a>
</li>
<li>
<b>About Me</b>
<br />
<ul class="navbarnested">
<li>
<a href="group-hug/">Group Hug</a>
</li>
<li>
<a href="cool-io/">Cool I/O</a>
</li>
</ul>
<ul class="navbarnested">
<li>
<a href="../resume.html">Resume</a>
</li>
</ul>
</li>
</ul>
<ul class="navbarmain">
<li>
<a href="../halifax/">Halifax</a>
</li>
</ul>
EOF

    # TEST
    ok (validate_nav_menu($rendered, $expected_string), 
        "Nav Menu with Separators"); 
}

#!/usr/bin/perl -w

use strict;

use Test::More tests => 3;

use Shlomif::NavMenu;

use HTML::Widgets::NavMenu::Test::Data;

my $test_data = get_test_data();

sub compare_string_arrays
{
    my $arr1 = shift;
    my $arr2 = shift;
    my $len_cmp = (@$arr1 <=> @$arr2);
    if ($len_cmp)
    {
        print STDERR "Len is not the same: " . scalar(@$arr1) . " vs. " . scalar(@$arr2) . "\n";
        return $len_cmp;
    }
    my $i;
    for($i=0;$i<@$arr1;$i++)
    {
        my $item_cmp = $arr1->[$i] cmp $arr2->[$i];
        if ($item_cmp)
        {
            print STDERR "Item[$i] is not the same:\narr1: $arr1->[$i]\narr2: $arr2->[$i]\n";
            return $item_cmp;
        }
    }
    return 0;
}

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

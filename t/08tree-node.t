#!/usr/bin/perl -w

use Test::More tests => 23;

use strict;

BEGIN {
use_ok ('Shlomif::NavMenu::Tree::Node'); # TEST
}

{
    my $node = Shlomif::NavMenu::Tree::Node->new();
    ok($node, "Constructing"); # TEST

    $node->set("url", "Rabbi/Zalman/");
    is($node->url(), "Rabbi/Zalman/", "Testing for URL Setting"); # TEST
    $node->set("value", "Trail of Innocence");
    is($node->value(), "Trail of Innocence", "Testing for value"); # TEST
    $node->set("show_always", 1);
    is($node->show_always(), 1, "Set/get show_always"); # TEST 
    $node->set("title", "It's Raining");
    is($node->title(), "It's Raining", "Set/get title"); # TEST
    $node->set("host", "vipe");
    is($node->host(), "vipe", "Set/get host"); # TEST

    # Testing again for the same values to see that they are still OK.

    is($node->url(), "Rabbi/Zalman/", "Testing for URL Setting"); # TEST
    is($node->value(), "Trail of Innocence", "Testing for value"); # TEST
    is($node->show_always(), 1, "Set/get show_always");  # TEST
    is($node->title(), "It's Raining", "Set/get title"); # TEST
    is($node->host(), "vipe", "Set/get host"); # TEST
}

{
    my $node = Shlomif::NavMenu::Tree::Node->new();

    ok ((!$node->separator()), "Testing Node Separator - False"); # TEST
    $node->set("separator", 1);
    ok ($node->separator(), "Testing Node Separator - True"); # TEST
}

{
    my $node = Shlomif::NavMenu::Tree::Node->new();

    ok ((!$node->hide()), "Testing Node Hide - False"); # TEST
    $node->set("hide", 1);
    ok ($node->hide(), "Testing Node Hide - True"); # TEST
}

{
    my $node = Shlomif::NavMenu::Tree::Node->new();

    is($node->role(), "normal", "Testing role default value"); # TEST
    $node->set("role", "hoola");
    is($node->role(), "hoola", "Testing role setted value"); # TEST
}

{
    my $node = Shlomif::NavMenu::Tree::Node->new();

    ok((!$node->expanded()), "Testing node->expanded()"); # TEST
    $node->expand();
    ok($node->expanded(), "Testing node->expanded() after expand()"); # TEST
}

{
    my $node = Shlomif::NavMenu::Tree::Node->new();

    ok((!$node->CurrentlyActive()), "Testing node->CurrentlyActive()"); # TEST
    $node->mark_as_current();
    # TEST
    ok($node->CurrentlyActive(), 
        "Testing node->CurAct() after mark_as_current()");
    # TEST
    ok($node->expanded(), 
        "Testing node->expanded() after mark_as_current()");
}


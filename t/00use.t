# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Shlomif-NavMenu.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 3;

# TEST
use_ok ('HTML::Widgets::NavMenu::HTML::Widget::SideBar');

# TEST
use_ok ('HTML::Widgets::NavMenu::Tree::Numbered');

# TEST
use_ok ('HTML::Widgets::NavMenu');


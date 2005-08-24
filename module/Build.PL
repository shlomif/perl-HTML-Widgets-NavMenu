#!/usr/bin/perl -w

use strict;

use Module::Build;

my $build = Module::Build->new(
    'module_name' => "HTML::Widgets::NavMenu",
    'requires' => 
    {
        'Test::More' => 0,
        'Class::Accessor' => 0,
        'Error' => 0,
        'perl' => "5.6.1",
        'IO::Scalar' => 0,
    },
    'license' => "bsd",
);
$build->create_build_script;

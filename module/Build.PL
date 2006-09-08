use strict;
use warnings;

use File::Spec;
use lib File::Spec->catdir(File::Spec->curdir(), "inc");

use Test::Run::Builder;

my $build = Test::Run::Builder->new(
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

use 5.008;

use strict;
use warnings FATAL => 'all';

use lib './inc';

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name         => 'HTML::Widgets::NavMenu::ToJSON',
    license             => 'Artistic_2_0',
    dist_author         => q{Shlomi Fish <shlomif@cpan.org>},
    dist_version_from   => 'lib/HTML/Widgets/NavMenu/ToJSON.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Carp' => 0,
        'HTML::Widgets::NavMenu::Object' => 0,
        'JSON' => 0,
        'YAML::XS' => 0,
        'parent' => 0,
        'strict' => 0,
        'warnings' => 0,
    },
    add_to_cleanup     => [ 'HTML-Widgets-NavMenu-ToJSON-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

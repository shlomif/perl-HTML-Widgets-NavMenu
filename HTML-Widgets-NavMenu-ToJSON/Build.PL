use 5.008;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
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
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => [ 'HTML-Widgets-NavMenu-ToJSON-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();

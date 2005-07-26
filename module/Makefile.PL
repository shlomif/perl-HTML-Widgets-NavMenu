use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'HTML::Widgets::NavMenu',
    VERSION_FROM      => 'lib/HTML/Widgets/NavMenu.pm', # finds $VERSION
    PREREQ_PM         =>
    {
        'Test::More' => 0,
        'Class::Accessor' => 0,
        'Error' => 0,
    },
    PL_FILES         => +{},
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (AUTHOR         => 'Shlomi Fish <shlomif@iglu.org.il>') : ()),
);

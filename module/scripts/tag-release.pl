#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($version) =
    (map { m{\$VERSION *= *'([^']+)'} ? ($1) : () }
    io->file("./lib/HTML/Widgets/NavMenu.pm")->getlines()
    )
    ;

if (!defined ($version))
{
    die "Version is undefined!";
}

my $mini_repos_url = "https://svn.berlios.de/svnroot/repos/web-cpan/nav-menu";

my @cmd = (
    "hg", "tag", "-m"
    "Tagging HTML-Widgets-NavMenu as $version",
    "cpan-releases/$version",
);

print join(" ", map { /\s/ ? qq{"$_"} : $_ } @cmd), "\n";
exec(@cmd);

#! /usr/bin/env perl
#
# Short description for split.pl
#
# Version 0.0.1
# Copyright (C) 2022 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp                                   qw/ confess /;
use Getopt::Long                           qw/ GetOptions /;
use Path::Tiny                             qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

my $obj = Docker::CLI::Wrapper::Container->new(
    { container => "rinutils--deb--test-build", sys => "debian:sid", } );

use Module::Format::Module;

sub replace
{
    my ( $self, $p, $body, $end ) = @_;

    my $module = Module::Format::Module->from(
        {
            format => 'colon',
            value  => $p,
        }
    );
    my $x = path( "lib/" . $module->format_as('unix') );
    $x->touchpath;
    $x->spew_utf8("package $p;\n$body\n$end\n");
    $obj->do_system( { cmd => [ "git", 'add', "$x", ] } );
    return "use $p ();\n" . $end;
}

sub run
{
    my $s = $_;
    my $output_fn;

    GetOptions( "output|o=s" => \$output_fn, )
        or die "errror in cmdline args: $!";

    if ( 0 and !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

    #    $obj->do_system( { cmd => [ "git", "clone", "-b", $BRANCH, $URL, ] } );

    while (
        $s =~ s#^package (HTML::Widgets::NavMenu::[^;]+);\n(.*?)^(package )#
replace(0, $1, $2, $3)
        #ems
        )
    {
        # body...
    }
    print $s;
    exit(0);
}

run();

1;

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::FromProto

=head1 VERSION

version v0.16.0

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut

#!/usr/bin/perl -w

use strict;
# TODO: Replace with a use lib thingy.
# 
use Shlomif::NavMenu;
use SitesData;

use CGI;

my $type = "good";

sub mymkdir
{
    my $dir = shift;
    if (! -e "$dir")
    {
        mkdir("$dir");
    }
}

sub create_file_dirs
{
    my $path = shift;
    my ($dir, @components);
    @components = split(/\//, $path);
    # Remove the filename.
    pop(@components);
    for(my $i=0;$i<@components;$i++)
    {
        my $dir_path = join("/", @components[0..$i]);
        mymkdir($dir_path);
    }
}

mymkdir("Output/$type");

{
    foreach my $site_ref (@{get_sites()})
    {
        process_site($site_ref);
    }
}

sub notice
{
    print STDERR @_, "\n";
}

sub process_site
{
    my $site_ref = shift;
    my $name = $site_ref->{'name'};
    notice("Now processing $name");
    my $site_dir = "Output/$type/$name";
    mymkdir($site_dir);
    foreach my $host_id (keys(%{$site_ref->{'hosts'}}))
    {
        my $host_dir = "$site_dir/$host_id";
        mymkdir($host_dir);
        foreach my $file (@{$site_ref->{'file_list'}->{$host_id}})
        {
            my $file_path = "$host_dir/$file";
            create_file_dirs($file_path);
            my $canonized_file = $file;
            $canonized_file =~ s{index\.html$}{};
            my $num_marks = 20;
            my $open_mark = "<" x $num_marks;
            my $close_mark = ">" x $num_marks;
            my $nav_menu = 
                Shlomif::NavMenu->new(
                    'path_info' => "/$canonized_file",
                    'current_host' => $host_id,
                    'hosts' => $site_ref->{'hosts'},
                    'tree_contents' => $site_ref->{'tree_contents'},
                );
            my $results = $nav_menu->render();
            open my $fh, ">$file_path";
            print {$fh} "NAV_MENU=\n$open_mark\n";
            print {$fh} map { "$_\n" } @{$results->{'html'}};
            print {$fh} "$close_mark\n";
            {
                my $nav_links = $results->{'nav_links'};
                my @keys = (sort { $a cmp $b } keys(%$nav_links));
                print {$fh} "NAV_LINKS=\n$open_mark\n";
                foreach my $key (@keys)
                {
                    my $url = $nav_links->{$key};
                    print {$fh} "<link rel=\"$key\" href=\"" . 
                        CGI::escapeHTML($url) . "\" />\n";
                }
                print {$fh} "$close_mark\n";
            }

            # TODO : add the nav-links, site-map, etc.
            close($fh);
        }
    }
}
1;


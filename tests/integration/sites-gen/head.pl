#!/usr/bin/perl -w

# This script tests the latest version of the code.

use strict;

use lib ($ENV{'HTML_NAVMENU_HEAD'} || "../../../module/lib/");

use HTML::Widgets::NavMenu;
use HTML::Widgets::NavMenu::HeaderRole;
use SitesData;

use CGI;

my $type = "head";

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

sub render_leading_path_component
{
    my $component = shift;
    my $title = $component->title();
    my $title_attr = defined($title) ? " title=\"$title\"" : "";
    return "<a href=\"" . CGI::escapeHTML($component->direct_url()) .
        "\"$title_attr>" .
        $component->label() . "</a>";
};

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
        notice("Now processing $host_dir");
        mymkdir($host_dir);
        my $count = 0;
        foreach my $file (@{$site_ref->{'file_list'}->{$host_id}})
        {
            my $file_path = "$host_dir/$file";
            create_file_dirs($file_path);
            my $canonized_file = $file;
            $canonized_file =~ s{index\.html$}{};
            my $num_marks = 20;
            my $open_mark = "<" x $num_marks;
            my $close_mark = ">" x $num_marks;
            my @args = 
                (
                    'path_info' => "/$canonized_file",
                    'current_host' => $host_id,
                    'hosts' => $site_ref->{'hosts'},
                    'tree_contents' => $site_ref->{'tree_contents'},
                    'ul_classes' => ["navbarmain", (("navbarnested") x 10)],
                );
            my $package = "HTML::Widgets::NavMenu";
            if (exists($site_ref->{'class'}))
            {
                if ($site_ref->{'class'} eq "HeaderRole")
                {
                    $package = "HTML::Widgets::NavMenu::HeaderRole";
                }
                else
                {
                    die "Unknown class " . $site_ref->{class} . "!";
                }
            }
            my $nav_menu = 
                $package->new(
                    @args,
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
            {
                print {$fh} "LEADING_PATH=\n$open_mark\n";
                print {$fh}
                    (map
                        { render_leading_path_component($_) . "\n" }
                        @{$results->{leading_path}}
                    );
                print {$fh} "$close_mark\n";
            }
            {
                print {$fh} "SITE_MAP=\n$open_mark\n";
                print {$fh} $nav_menu->gen_site_map();
                print {$fh} "$close_mark\n";
            }
            
            # TODO : add the nav-links, site-map, etc.
            close($fh);
        }
        continue
        {
            $count++;
            if ($count % 10 == 0)
            {
                notice("Processed $count files out of $host_dir");
            }
        }
    }
}

open my $stamp, ">$type.stamp";
print {$stamp} "";
close($stamp);

1;


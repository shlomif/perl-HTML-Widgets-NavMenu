
my $shlomif_hosts =
{
    't2' => 
    {
        'base_url' => "http://www.shlomifish.org/",
    },
    'vipe' =>
    {
        'base_url' => "http://vipe.technion.ac.il/~shlomif/",
    },
};

my $shlomif_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish",
    'title' => "Shlomi Fish' Homepage",
    'subs' =>
    [
        {
            'text' => "Home",
            'url' => "",
        },
        {
            'text' => "About Myself",
            'url' => "me/",
            'subs' => 
            [
                {
                    'text' => "Bio",
                    'url' => "personal.html",
                    'title' => "A Short Biography of Myself",
                },
                {
                    'text' => "Contact",
                    'url' => "me/contact-me/",
                    'title'=> "How to Contact me in Every Conceivable Way",
                },
                {
                    'text' => "My Resum&eacute;s",
                    'url' => "me/resumes/",
                    'subs' =>
                    [
                        {
                            'text' => "English Resum&eacute;",
                            'url' => "SFresume.html",
                            'skip' => 1,
                        },
                        {
                            'text' => "Detailed English Resum&eacute;",
                            'url' => "SFresume_detailed.html",
                            'skip' => 1,
                        },
                    ],
                },
            ],               
        },
        {
            'text' => "Work",
            'url' => "work/",
            'title' => "Work-Related Pages",
            'show_always' => 1,
            'subs' => 
            [
                {
                    'text' => "Private Lessons",
                    'url' => "work/private-lessons/",
                    'title' => "I'm Giving Private Lessons for High School Subjects and Computing.",
                },
            ],
        },
        {
            'text' => "Humour", 
            'url' => "humour/",
            'title' => "My Humorous Creations",
            'subs' => 
            [
                {
                    'text' => "The Enemy", 
                    'url' => "humour/TheEnemy/",
                    'title' => "The Enemy and How I Helped to Fight It",
                },
                {
                    'text' => "TOWTF",
                    'url' => "humour/TOWTF/",
                    'title' => "The One with the Fountainhead",
                },
                {
                    'text' => "The Pope",
                    'url' => "humour/Pope/",
                    'title' => "The Pope Died on Sunday",
                },
                {
                    'text' => "Humour Archive",
                    'title' => "Archive of Humorous Bits I came up with",
                    'url' => "humour.html",
                    'hide' => 1,
                },
                {
                    'text' => "Fortune Cookies Collection",
                    'title' => "Collection of Files for Input to the UNIX 'fortune' Program",
                    'url' => "humour/fortunes/",
                    'host' => "vipe",
                    'hide' => 1,
                },
            ],
        },
        {
            'text' => "Math-Ventures",
            'url' => "MathVentures/",
            'title' => "Mathematical Riddles and their Solutions",
        },
        {
            'text' => "Computer Art",
            'url' => "art/",
            'title' => "Computer art I created while explaining how.",
            'subs' =>
            [
                {
                    'text' => "Back to my Homepage",
                    'url' => "art/bk2hp/",
                    'title' => "A Back to my Homepage logo not unlike the one from the movie &quot;Back to the Future&quot;",
                },
                {
                    'text' => "Linux Banner",
                    'url' => "art/linux_banner/",
                    'title' => "Linux - Because Software Problems should not Cost Money",
                },
            ],
        },
        {
            'text' => "Software",
            'url' => "open-source/",
            'expand' => { 're' => "^open-source/" },
            'title' => "Pages related to Software (mostly Open-Source)",
            'subs' => 
            [
                {
                    'text' => "Freecell Solver",
                    'url' => "open-source/projects/freecell-solver/",
                },
                {
                    'text' => "MikMod for Java",
                    'title' => "A Player for MOD Files (a type of Music Files) for the Java Environment",
                    'url' => "jmikmod/",
                },
                {
                    'text' => "FCFS RWLock",
                    'title' => "A First-Come First-Served Readers/Writers Lock",
                    'url' => "rwlock/",
                    'host' => "vipe",
                },
                {
                    'text' => "Quad-Pres",
                    'title' => "A Tool for Creating HTML Presentations",
                    'url' => "open-source/projects/quad-pres/",
                },
                {
                    'text' => "Favourite OSS",
                    'title' => "Favourite Open-Source Software",
                    'url' => "open-source/favourite/",
                },
                {
                    'text' => "Interviews",
                    'title' => "Interviews with Open-Source People",
                    'url' => "open-source/interviews/",
                },
                {
                    'text' => "Contributions",
                    'title' => "Contributions to Other Projects, that I did not Start",
                    'url' => "open-source/contributions/",
                },
                {
                    'text' => "Bits and Bobs",
                    'title' => "Various Small-Scale Open-Source Works",
                    'url' => "open-source/bits.html",
                },
                {
                    'text' => "Portability Libraries",
                    'title' => "Cross-Platform Abstraction Libraries",
                    'url' => "abstraction/",
                    'host' => "vipe",
                    'hide' => 1,
                },
                {
                    'text' => "Software Tools",
                    'title' => "Software Constructions and Management Tools",
                    'url' => "software-tools/",
                    'host' => "vipe",
                    'hide' => 1,
                },
            ],
        },
        {
            'text' => "Lectures", 
            'url' => "lecture/",
            'expand' => { 're' => "^lecture/" },
            'title' => "Presentations I Wrote (Mostly Technical)",
            'host' => "vipe",
            'subs' => 
            [
                {
                    'text' => "Perl for Newbies",
                    'url' => "lecture/Perl/Newbies/",
                },
                {
                    'text' => "Freecell Solver",
                    'url' => "lecture/Freecell-Solver/",
                },
                {
                    'text' => "Lambda Calculus",
                    'title' => "A presentation about a Turing-complete programming environment with only two primitives",
                    'url' => "lecture/lc/",
                },
                {
                    'text' => "The Gimp",
                    'title' => "A Presentation about the GNU Image Manipulation Program",
                    'url' => "lecture/Gimp/",
                },
                {
                    'text' => "GNU Autotools",
                    'url' => "lecture/Autotools/",
                },
                {
                    'text' => "Web Meta Lecture",
                    'title' => "A Presentation about the Web Meta Language",
                    'url' => "lecture/WebMetaLecture/",
                },
            ],
        },
        {
            'text' => "Essays",
            'url' => "philosophy/",
            'title' => "Various Essays and Articles about Technology and Philosophy in General",
            'subs' =>
            [
                {
                    'text' => "Index to Essays",
                    'url' => "philosophy/Index/",
                    'title' => "Index to Essays and Articles I wrote.",
                },
                {
                    'text' => "What is Open Source?",
                    'url' => "philosophy/foss-other-beasts/",
                    'title' => "Free Software, Open Source and Other Beasts",
                },
                {
                    'text' => "Perl &amp; Newcomers",
                    'url' => "philosophy/perl-newcomers/",
                    'title' => "&quot;Usability&quot; of the Perl Online World for Newcomers",
                },
                {
                    'text' => "Objectivism and Open Source",
                    'url' => "philosophy/obj-oss/",
                    'title' => "Objectivism and Open Source",
                },
                {
                    'text' => "The Eternal Jew",
                    'url' => "philosophy/the-eternal-jew/",
                    'title' => "The Eternal Jew - An Essay about Philosophy",
                },
            ],
        },
        {
            'text' => "Opinion on DeCSS",
            'url' => "DeCSS/",
            'title' => "My Opinion on the DeCSS (= DVDs' de-scrambling code) fiasco",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'text' => "Cool Links",
            'url' => "links.html",
            'title' => "An incomplete list of links I find cool and/or useful.",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'url' => "site-source/",
            'text' => "Site's Source",
            'title' => "The source code used to generate this site",
        },
    ],
};

sub get_file_list_from_file
{
    my $filename = shift;
    my $buffer = "";
    {
        local $/;
        open my $f, "<$filename";
        $buffer = <$f>;
        close($f);
    }
    return [ split(/\s+/, $buffer) ];
}

my $shlomif_file_list = +{ map { $_ => get_file_list_from_file("$_-filelist.txt") } (qw(t2 vipe)) };

my $perl_begin_hosts =
{
    'berlios' => 
    {
        'base_url' => "http://perl-begin.berlios.de/",
    },
};

my $perl_begin_tree_contents =
{
    'host' => "berlios",
    'text' => "Perl Beginners' Site",
    'title' => "A useful Portal for People New to Perl",
    'subs' =>
    [
        {
            'text' => "Home",
            'url' => "",
        },
        {
            'text' => "About",
            'url' => "about.html",
        },
        {
            'text' => "News",
            'url' => "news/",
            'title' => "Previous News Item",
        },
        {
            'text' => "Online Tutorials",
            'url' => "tutorials/",
            'subs' =>
            [
                {
                    'text' => "In Other Languages",
                    'url' => "tutorials/localized/",
                    'title' => "Tutorials in languages other than English",
                },
            ],
        },
        {
            'text' => "Books",
            'url' => "books/",
            'subs' =>
            [
                {
                    'url' => "books/advanced/",
                    'text' => "Advanced Books",
                    'title' => "Books that contain more information about Perl than the basics",
                },
                {
                    'url' => "books/topics/",
                    'text' => "Topic-related Books",
                    'title' => "Books that cover certain topics in detail",
                },
            ],
        },
        {
            'url' => "core-doc/",
            'text' => "Core Documentation",
        },
        {
            'url' => "articles/",
            'text' => "Article Collections",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'text' => "Mailing Lists",
            'url' => "mailing-lists/",
            'title' => "Ask questions and receive answers about Perl by E-mail",
        },
        {
            'text' => "Web Forums",
            'url' => "web-forums/",
            'title' => "Ask questions and receive answers by using a web-browser",
        },
        {
            'text' => "IRC Channels",
            'url' => "irc/",
            'title' => "Chat online about Perl using the Internet Relay Chat (IRC)",
        },
        {
            'text' => "Site Resources",
            'url' => "site-resources/",
            'role' => "header",
            'show_always' => 1,
            'subs' =>
            [
                {
                    'text' => "Mailing List",
                    'url' => "site-resources/mailing-list/",
                    'title' => "A mailing list for helping Beginners",
                },
                {
                    'text' => "Wiki",
                    'title' => "A sub-site that can be freely edited with any information",
                    'url' => "site-resources/wiki/",
                },
                {
                    'text' => "Web Forum",
                    'url' => "site-resources/web-forum/",
                    'title' => "A web-based forum where you can post messages",
                },
            ],
        },
        {
            'text' => "Platforms",
            'url' => "platforms/",
            'role' => "header",
            'show_always' => 1,
            'subs' =>
            [
                {
                    'text' => "Mac OS",
                    'url' => "platforms/mac/",
                    'title' => "Macintosh and PowerPC/PowerMac Platforms",
                },
                {
                    'text' => "UNIX/Linux",
                    'url' => "platforms/unix/",
                },
                {
                    'text' => "Windows",
                    'url' => "platforms/windows/",
                },
            ],
        },
        {
            'text' => "Uses",
            'url' => "uses/",
            'title' => "Common Uses for Perl",
            'role' => "header",
            'show_always' => 1,
            'subs' =>
            [
                {
                    'text' => "Bio-Informatics",
                    'url' => "uses/bio-info/",
                },
                {
                    'text' => "QA and Testing",
                    'url' => "uses/qa/",
                },
                {
                    'text' => "Sys Admin",
                    'title' => "Using Perl for System Administration",
                    'url' => "uses/sys-admin/",
                },
                {
                    'text' => "Web/CGI",
                    'url' => "uses/web/",
                },
            ],
        },
        {
            'text' => "Contribute",
            'url' => "contribute/",
            'title' => "Contribute new content or corrections to this site",
            'role' => "header",
            'show_always' => 1,
            'subs' =>
            [
                {
                    'text' => "Site's Source Code",
                    'url' => "source/",
                },
            ],
        },
    ],
};

my $perl_begin_file_list = +{ 'berlios' => get_file_list_from_file("perl-begin-filelist.txt"), };

my @sites =
(
    {
        'name' => "shlomif",
        'comment' => "Shlomi Fish' Homepage as of 8-December-2004",
        'hosts' => $shlomif_hosts,
        'tree_contents' => $shlomif_tree_contents,
        'file_list' => $shlomif_file_list,
    },
    {
        'name' => "perl-begin",
        'comment' => "The Perl Beginners' Site as of 23-Dec-2004",
        'hosts' => $perl_begin_hosts,
        'tree_contents' => $perl_begin_tree_contents,
        'file_list' => $perl_begin_file_list,
        'class' => "HeaderRole",
    },    
);

sub get_sites
{
    return \@sites;
}

1;

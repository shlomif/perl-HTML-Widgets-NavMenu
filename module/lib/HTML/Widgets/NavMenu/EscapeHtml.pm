package HTML::Widgets::NavMenu::EscapeHtml;

use base qw(Exporter);

use vars qw(@EXPORT);

@EXPORT=(qw(escape_html));

sub escape_html
{
    my $string = shift;
    $string =~ s{&}{&amp;}gso;
    $string =~ s{<}{&lt;}gso;
    $string =~ s{>}{&gt;}gso;
    $string =~ s{"}{&quot;}gso;
    return $string;
}

1;


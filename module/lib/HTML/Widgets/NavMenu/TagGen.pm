package HTML::Widgets::NavMenu::TagGen;

use base 'HTML::Widgets::NavMenu::Object';
use base 'Class::Accessor';

use HTML::Widgets::NavMenu::EscapeHtml;

__PACKAGE__->mk_accessors(
    qw(name attributes)
);

sub initialize
{
    my $self = shift;

    my (%args) = (@_);

    $self->name($args{'name'});
    $self->attributes($args{'attributes'});

    return 0;
}

sub gen
{
    my $self = shift;

    my $attr_values = shift;

    my $is_standalone = shift || 0;

    my @tag_list = keys(%$attr_values);

    @tag_list = (grep { defined($attr_values->{$_}) } @tag_list);

    @tag_list = (sort { $a cmp $b } @tag_list);

    my $attr_spec = $self->attributes();

    return "<" . $self->name() . 
        join("", map { " $_=\"" .
            ($attr_spec->{$_}->{'escape'} ? 
                escape_html($attr_values->{$_}) 
                : $attr_values->{$_}
            ) . "\""
            } @tag_list) .
        ($is_standalone ? " /" : "") . ">";
}

1;


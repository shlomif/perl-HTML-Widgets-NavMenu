package HTML::Widgets::NavMenu::Iterator::Html;

use base qw(HTML::Widgets::NavMenu::Iterator::Base);

sub node_start
{
    my $self = shift;

    if ($self->_is_root())
    {
        return $self->start_root();
    }
    elsif ($self->_is_top_separator())
    {
        # start_sep() is short for start_separator().
        return $self->start_sep();
    }
    else
    {
        return $self->start_regular();
    }
}

sub node_end
{
    my $self = shift;

    if ($self->_is_root())
    {
        return $self->end_root();
    }
    elsif ($self->_is_top_separator())
    {
        return $self->end_sep();
    }
    else
    {
        return $self->end_regular();
    }
}

sub end_root
{
    my $self = shift;

    $self->_add_tags("</ul>");
}

sub end_regular
{
    my $self = shift;
    if ($self->top()->num_subs() && $self->is_expanded())
    {
        $self->_add_tags("</ul>");
    }
    $self->_add_tags("</li>");
}

sub node_should_recurse
{
    my $self = shift;
    return $self->is_expanded();
}

# Get the HTML <a href=""> tag.
#
sub get_a_tag
{
    my $self = shift;
    my $item = $self->top();
    my $node = $item->node;

    my $tag ="<a";
    my $title = $node->title;

    $tag .= " href=\"" .
        CGI::escapeHTML(
            $self->nav_menu()->get_cross_host_rel_url(
                'host' => $self->_get_top_host(),
                'host_url' => $node->url(),
                'url_type' => 
                    ($node->url_type() ||
                        $item->accum_state()->{'rec_url_type'} ||
                        "rel"),
            )
        ). "\"";
    if (defined($title))
    {
        $tag .= " title=\"$title\"";
    }
    $tag .= ">" . $node->text() . "</a>";
    return $tag;
}

1;


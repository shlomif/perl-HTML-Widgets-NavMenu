package Shlomif::NavMenu::Iterator::Html;

use base qw(Shlomif::NavMenu::Iterator::Base);

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
    if ($self->top()->num_subs() && $self->is_active())
    {
        $self->_add_tags("</ul>");
    }
    $self->_add_tags("</li>");
}

sub node_should_recurse
{
    my $self = shift;
    return $self->is_active();    
}

1;


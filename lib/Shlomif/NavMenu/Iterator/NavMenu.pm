package Shlomif::NavMenu::Iterator::NavMenu;

use base qw(Shlomif::NavMenu::Iterator::Html);

sub start_root
{
    my $self = shift;
    
    $self->_add_tags("<ul class=\"navbarmain\">");
}

sub start_sep
{
    my $self = shift;

    $self->_add_tags("</ul>");
}


sub start_regular
{
    my $self = shift;

    my $top_item = $self->top;
    my $node = $self->top->node();

    if ($self->is_hidden())
    {
        # Do nothing
    }
    else
    {
        my $tag;
        if ($node->{'CurrentlyActive'})
        {
            $tag = "<b>" . $node->{value} . "</b>";
        }
        else
        {
            $tag = $self->get_a_tag();
        }
        my @tags_to_add;
        if ($self->is_role_header())
        {
            @tags_to_add = ("</ul>","<h2>", $tag, "</h2>",
                "<ul class=\"navbarmain\">");
        }
        else
        {
            @tags_to_add = ("<li>", $tag);
            if ($top_item->num_subs_to_go() && $self->is_active())
            {
                push @tags_to_add, 
                    ("<br />", "<ul class=\"navbarnested\">");
            }
        }
        $self->_add_tags(@tags_to_add);
    }
}

sub end_sep
{
    my $self = shift;
    my $class =
        ($self->stack->len() <= 2) ?
            "navbarmain" :
            "navbarnested";
    $self->_add_tags("<ul class=\"$class\">");
}

sub end_regular
{
    my $self = shift;
    if ($self->is_hidden() || $self->is_role_header())
    {
        # Do nothing
    }
    else
    {
        return $self->SUPER::end_regular();
    }
}

sub is_hidden
{
    my $self = shift;
    return $self->top->node()->{'hide'};
}

sub is_active
{
    my $self = shift;
    my $node = $self->top->node();
    return ($node->{'Active'} || $self->top->accum_state->{'show_always'});
}

sub is_role_header
{
    my $self = shift;
    return ($self->top->node->{'role'} eq "header");
}

1;


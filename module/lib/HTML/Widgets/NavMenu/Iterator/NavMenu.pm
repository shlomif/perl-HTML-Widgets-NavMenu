package HTML::Widgets::NavMenu::Iterator::NavMenu;

use base qw(HTML::Widgets::NavMenu::Iterator::Html);

use CGI;

sub gen_ul_tag
{
    my $self = shift;

    my %args = (@_);

    my $depth = $args{'depth'};

    my $class = $self->get_ul_class('depth' => $depth);

    return "<ul" .
        (defined($class) ?
            (" class=\"" . CGI::escapeHTML($class) . "\"") :
            ""
        ) . ">";
}

sub get_ul_class
{
    my $self = shift;

    my %args = (@_);

    my $depth = $args{'depth'};

    return ($depth <= 1) ? "navbarmain" : "navbarnested";
}

sub start_root
{
    my $self = shift;
    
    $self->_add_tags($self->gen_ul_tag('depth' => $self->stack->len()));
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
        if ($node->CurrentlyActive())
        {
            $tag = "<b>" . $node->value() . "</b>";
        }
        else
        {
            $tag = $self->get_a_tag();
        }
        my @tags_to_add;
        if ($self->is_role_header())
        {
            @tags_to_add = ("</ul>","<h2>", $tag, "</h2>",
                $self->gen_ul_tag('depth' => $self->stack->len()-1)
                );
        }
        else
        {
            @tags_to_add = ("<li>", $tag);
            if ($top_item->num_subs_to_go() && $self->is_expanded())
            {
                # TODO:
                # Should it be 'depth' => $self->stack->len() + 1?
                # Check further.
                push @tags_to_add, 
                    ("<br />", $self->gen_ul_tag('depth' => $self->stack->len()));
            }
        }
        $self->_add_tags(@tags_to_add);
    }
}

sub end_sep
{
    my $self = shift;

    $self->_add_tags($self->gen_ul_tag('depth' => $self->stack->len()-1));
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
    return $self->top->node()->hide();
}

sub is_expanded
{
    my $self = shift;
    my $node = $self->top->node();
    return ($node->expanded() || $self->top->accum_state->{'show_always'});
}

sub is_role_header
{
    my $self = shift;
    return ($self->top->node->role() eq "header");
}

1;


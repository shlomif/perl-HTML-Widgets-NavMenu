package HTML::Widgets::NavMenu::Iterator::NavMenu;

use strict;

use base qw(HTML::Widgets::NavMenu::Iterator::Html);

use CGI;

sub initialize
{
    my $self = shift;

    $self->SUPER::initialize(@_);

    my %args = (@_);

    my $ul_classes = ($args{'ul_classes'} || []);
    # Make a fresh copy just to be on the safe side.
    $self->{'ul_classes'} = [ @$ul_classes ];

    return 0;
}

# Depth is 1 for the uppermost depth.
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

    return $self->{'ul_classes'}->[$depth-1];
}
 
# This functions get something like either <a href="./mydir">Link Value</a>
# or <b>Link Value</b>
sub get_link_tag
{
    my $self = shift;
    my $node = $self->top->node();
    if ($node->CurrentlyActive())
    {
        return "<b>" . $node->text() . "</b>";
    }
    else
    {
        return $self->get_a_tag();
    }
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

sub start_handle_role
{
    my $self = shift;
    return $self->start_handle_non_role();
}

sub start_handle_non_role
{
    my $self = shift;
    my $top_item = $self->top;
    my @tags_to_add = ("<li>", $self->get_link_tag());
    if ($top_item->num_subs_to_go() && $self->is_expanded())
    {
        push @tags_to_add, 
            ("<br />", $self->gen_ul_tag('depth' => $self->stack->len()));
    }
    $self->_add_tags(@tags_to_add);
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
        if ($self->is_role_specified())
        {
            $self->start_handle_role();
        }
        else
        {
            $self->start_handle_non_role();
        }
    }
}

sub end_sep
{
    my $self = shift;

    $self->_add_tags($self->gen_ul_tag('depth' => $self->stack->len()-1));
}

sub end_handle_role
{
    my $self = shift;
    return $self->end_handle_non_role();
}

sub end_handle_non_role
{
    my $self = shift;
    return $self->SUPER::end_regular();
}

sub end_regular
{
    my $self = shift;
    if ($self->is_hidden())
    {
        # Do nothing
    }
    elsif ($self->is_role_specified())
    {
        $self->end_handle_role();
    }
    else
    {
        $self->end_handle_non_role();
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

sub get_role
{
    my $self = shift;
    return $self->top->node->role();
}

sub is_role_specified
{
    my $self = shift;
    return defined($self->get_role());
}

1;


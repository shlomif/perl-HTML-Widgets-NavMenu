package Shlomif::NavMenu::Iterator::NavMenu;

use base qw(Shlomif::NavMenu::Iterator::Base);

sub node_start
{
    my $self = shift;

    my $top_item = $self->top;
    my $node = $self->top->node();

    my $nav_menu = $self->{'nav_menu'};

    if ($self->_is_root())
    {
        $self->_add_tags("<ul class=\"navbarmain\">");
    }
    else
    {
        if ($self->_is_top_separator())
        {
            $self->_add_tags("</ul>");
        }
        else
        {
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
                    $tag ="<a";
                    my $title = $node->{'title'};
                    $tag .= " href=\"" . 
                        CGI::escapeHTML(
                            $nav_menu->get_cross_host_rel_url(
                                'host' => $self->_get_top_host(),
                                'host_url' => $node->{url},
                                'abs_url' => $node->{abs_url},
                            )
                        ). "\"";
                    if (defined($title))
                    {
                        $tag .= " title=\"$title\"";
                    }
                    $tag .= ">" . $node->{value} . "</a>";
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
    }
}

sub node_end
{
    my $self = shift;

    if ($self->_is_root())
    {
        $self->_add_tags("</ul>");
    }
    else
    {
        if ($self->_is_top_separator())
        {
            my $class =
                ($self->stack->len() <= 2) ?
                    "navbarmain" :
                    "navbarnested";
            $self->_add_tags("<ul class=\"$class\">");
        }
        elsif ($self->is_hidden() || $self->is_role_header())
        {
            # Do nothing
        }
        else
        {
            if ($self->top()->num_subs() && $self->is_active())
            {
                $self->_add_tags("</ul>");
            }
            $self->_add_tags("</li>");
        }
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

sub node_should_recurse
{
    my $self = shift;
    return $self->is_active();    
}

1;


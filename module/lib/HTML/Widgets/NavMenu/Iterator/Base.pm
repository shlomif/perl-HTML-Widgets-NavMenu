package HTML::Widgets::NavMenu::Iterator::Base;

use strict;
use warnings;

use base qw(HTML::Widgets::NavMenu::Tree::Iterator);

use CGI;

sub initialize
{
    my $self = shift;

    $self->SUPER::initialize(@_);

    my %args = (@_);

    $self->{'nav_menu'} = $args{'nav_menu'} or
        die "nav_menu not specified!";

    $self->{'html'} = [];

    return 0;
}

sub nav_menu
{
    my $self = shift;
    return $self->{'nav_menu'};
}

sub _add_tags
{
    my $self = shift;
    push (@{$self->{'html'}}, @_);
}

sub _is_root
{
    my $self = shift;

    return ($self->stack->len() == 1);
}

sub _is_top_separator
{
    my $self = shift;

    return $self->top->node->separator;
}

sub _get_top_host
{
    my $self = shift;

    return 
        $self->top->accum_state->{'host'};
}

sub get_initial_node
{
    my $self = shift;
    return $self->nav_menu->get_traversed_tree();
}

sub get_node_subs
{
    my $self = shift;
    my %args = (@_);
    my $node = $args{'node'};
    return [ @{$node->subs()} ];
}

sub get_new_accum_state
{
    my $self = shift;
    my %args = (@_);
    my $parent_item = $args{'item'};
    my $node = $args{'node'};
    
    my $prev_state;
    if (defined($parent_item))
    {
        $prev_state = $parent_item->accum_state();
    }
    else
    {
        $prev_state = +{};
    }

    my $show_always = 0;
    if (exists($prev_state->{'show_always'}))
    {
        $show_always = $prev_state->{'show_always'};
    }
    if (defined($node->show_always()))
    {
        $show_always = $node->show_always();
    }
    
    my $rec_url_type;
    if (exists($prev_state->{'rec_url_type'}))
    {
        $rec_url_type = $prev_state->{'rec_url_type'};
    }
    if (defined($node->rec_url_type()))
    {
        $rec_url_type = $node->rec_url_type();
    }
    return
        {
            'host' => ($node->host() || $prev_state->{'host'}),
            'show_always' => $show_always,
            'rec_url_type' => $rec_url_type,
        };
}

sub get_results
{
    my $self = shift;

    return join("", map { "$_\n" } @{$self->{'html'}});
}

1;


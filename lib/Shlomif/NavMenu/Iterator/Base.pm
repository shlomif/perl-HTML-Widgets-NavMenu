package Shlomif::NavMenu::Iterator::Base;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Tree::Iterator);

use CGI;

sub initialize
{
    my $self = shift;

    $self->SUPER::initialize(@_);

    my %args = (@_);

    $self->{'nav_menu'} = $args{'nav_menu'} or
        die "nav_menu not specified!";

    $self->{'tree'} = ($args{'tree'} || $self->{'nav_menu'}->{'tree_contents'});

    $self->{'html'} = [];

    return 0;
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

    return $self->top->node->{'separator'};
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
    return $self->{'tree'};
}

sub get_node_subs
{
    my $self = shift;
    my %args = (@_);
    my $node = $args{'node'};
    return
        exists($node->{subs}) ?
            [ @{$node->{subs}} ] :
            [];
}

sub get_new_accum_state
{
    my $self = shift;
    my %args = (@_);
    my $parent_item = $args{'item'};
    my $node = $args{'node'};

    if (!defined($parent_item))
    {
        return { 'host' => $node->{'host'} };
    }

    my $prev_state = 
        $parent_item->accum_state();

    return { 'host' => ($node->{'host'} || $prev_state->{'host'}) };
}

sub get_results
{
    my $self = shift;

    return join("", map { "$_\n" } @{$self->{'html'}});
}

1;


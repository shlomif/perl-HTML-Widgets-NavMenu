package Shlomif::NavMenu::Tree::Iterator;

use strict;
use warnings;

use base qw(Shlomif::NavMenu::Object);

sub initialize
{
    my $self = shift;

    $self->{'stack'} = [];

    return 0;
}

sub _get_stack
{
    my $self = shift;

    return $self->{'stack'};
}

sub _stack_get_num_elems
{
    my $self = shift;

    return scalar(@{$self->_get_stack()});
}

sub _stack_is_empty
{
    my $self = shift;

    return ($self->_stack_get_num_elems() == 0);
}

sub _stack_get_top_item
{
    my $self = shift;

    my $stack = $self->_get_stack();

    return $stack->[-1];
}

sub _stack_pop
{
    my $self = shift;
    pop(@{$self->_get_stack()});
}

sub push_into_stack
{
    my $self = shift;

    my %args = (@_);
    my $node = $args{'node'};
    my $parent_record = 
        ($self->_stack_is_empty() ? 
            +{} : 
            $self->_stack_get_top_item()
        );
    
    my $record = +{};
    $record->{'node'} = $node;
    my $subs = 
        exists($node->{subs}) ? 
            [ @{$node->{subs}} ] : 
            [];
    $record->{'remaining_subs'} = $subs;
    $record->{'num_subs'} = scalar(@$subs);
    $record->{'status'} = 0;
    $record->{'host'} = $node->{host} || $parent_record->{host};

    push @{$self->_get_stack()}, $record;
}

sub traverse
{
    my $self = shift;

    my $nav_menu = shift;
    my $path_info = $nav_menu->path_info();

    $self->push_into_stack('node' => $nav_menu->{'tree_contents'} );

    my @html;

    $self->{'html'} = \@html;

    $self->_add_tags("<ul>");
    MAIN_LOOP: while (! $self->_stack_is_empty())
    {
        my $top_item = $self->_stack_get_top_item();
        my $status = $top_item->{'status'};
        my $node = $top_item->{'node'};
        my $is_separator = $node->{separator};

        my $not_root = ($self->_stack_get_num_elems() > 1);
        
        if ((! $is_separator) && $not_root && (! $status))
        {
            $self->_add_tags("<li>");
            $top_item->{status} = 1;
            my $tag = "<a";
            my $title = $node->{'title'};
            $tag .= " href=\"" . 
                CGI::escapeHTML(
                    $nav_menu->get_cross_host_rel_url(
                        'host' => $top_item->{host},
                        'host_url' => $node->{url},
                        'abs_url' => $node->{abs_url},
                    )
                ). "\"";
            if (defined($title))
            {
                $tag .= " title=\"$title\"";
            }
            $tag .= ">" . $node->{value} . "</a>";

            if (defined($title))
            {
                $tag .= " - $title";
            }
            $self->_add_tags($tag);
        }
        my $rem_subs = $top_item->{'remaining_subs'};
        if (@$rem_subs)
        {
            if ((!$status) && $not_root)
            {
                $self->_add_tags("<br />");
                $self->_add_tags("<ul>");
            }
            my $new_item = shift(@$rem_subs);
            $self->push_into_stack('node' => $new_item);
            next MAIN_LOOP;
        }
        else
        {
            if ($not_root && (! $is_separator))
            {
                if ($top_item->{'num_subs'})
                {
                    $self->_add_tags("</ul>");
                }
                $self->_add_tags("</li>");
            }
            $self->_stack_pop();
        }
    }
    $self->_add_tags("</ul>");
    return join("", map { "$_\n" } @html);
}


1;


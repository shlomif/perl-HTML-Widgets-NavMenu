package HTML::Widgets::NavMenu::NodeDescription;

use strict;
use warnings;

use parent qw(HTML::Widgets::NavMenu::Object);

__PACKAGE__->mk_acc_ref( [qw(host host_url title label direct_url url_type)] );

sub _init
{
    my ( $self, $args ) = @_;

    while ( my ( $k, $v ) = each(%$args) )
    {
        $self->$k($v);
    }

    return 0;
}

1;

__END__

=encoding utf8

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 direct_url()

B<internal use>

=head2 host()

B<internal use>

=head2 host_url()

B<internal use>

=head2 label()

B<internal use>

=head2 title()

B<internal use>

=head2 url_type()

B<internal use>


=cut

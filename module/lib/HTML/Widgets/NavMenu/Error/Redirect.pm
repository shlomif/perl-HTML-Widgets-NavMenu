package HTML::Widgets::NavMenu::Error::Redirect;

use strict;
use warnings;

use parent "HTML::Widgets::NavMenu::Error";

sub CGIpm_perform_redirect
{
    my $self = shift;

    my $cgi = shift;

    print $cgi->redirect( $cgi->script_name() . $self->{-redirect_path} );
    exit;
}

1;

__END__

=encoding utf8

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 METHODS

=head2 CGIpm_perform_redirect()

B<TBD.>

=cut


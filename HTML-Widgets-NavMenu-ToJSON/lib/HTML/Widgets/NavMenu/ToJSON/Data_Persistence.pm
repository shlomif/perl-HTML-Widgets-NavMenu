package HTML::Widgets::NavMenu::ToJSON::Data_Persistence;

use 5.008;
use strict;
use warnings FATAL => 'all';

use parent 'HTML::Widgets::NavMenu::Object';

__PACKAGE__->mk_acc_ref(
    [
        qw(
            _data
        ),
    ]
);

=head1 NAME

HTML::Widgets::NavMenu::ToJSON::Data_Persistence - Data persistence base class.

=head1 VERSION

Version 0.0.3

=cut

our $VERSION = '0.0.3';


=head1 SYNOPSIS

See L<HTML::Widgets::NavMenu::ToJSON> .

    use HTML::Widgets::NavMenu::ToJSON::Data_Persistence;

    my $foo = HTML::Widgets::NavMenu::ToJSON::Data_Persistence->new();

=head1 SUBROUTINES/METHODS

=head2 $self->get_id_for_url($url)

Returns the id (an integer) for the url fragment $url . If an ID does not
exist, a new ID will be assigned and the old one incremented.

=cut

sub _get_id_persistence
{
    my $self = shift;

    return $self->_data->{id_persistence};
}

sub _calc_initial_data
{
    my $self = shift;

    return { id_persistence => { paths_ids => { }, next_id => 1, }, };
}

sub get_id_for_url
{
    my ($self, $url) = @_;

    my $ptr = $self->_get_id_persistence;

    if (! exists($ptr->{paths_ids}->{$url}))
    {
        $ptr->{paths_ids}->{$url} = ($ptr->{next_id}++);
    }

    return $ptr->{paths_ids}->{$url};
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-widgets-navmenu-tojson at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-Widgets-NavMenu-ToJSON>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::Widgets::NavMenu::ToJSON::Data_Persistence


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTML-Widgets-NavMenu-ToJSON>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTML-Widgets-NavMenu-ToJSON>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTML-Widgets-NavMenu-ToJSON>

=item * Search CPAN

L<http://search.cpan.org/dist/HTML-Widgets-NavMenu-ToJSON/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Shlomi Fish.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of HTML::Widgets::NavMenu::ToJSON::Data_Persistence

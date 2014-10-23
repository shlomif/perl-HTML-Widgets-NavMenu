package HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML;

use 5.008;
use strict;
use warnings FATAL => 'all';

use parent 'HTML::Widgets::NavMenu::ToJSON::Data_Persistence';

use YAML::XS ();

=head1 NAME

HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML - YAML-based persistence
for L<HTML::Widgets::NavMenu::ToJSON> .

=head1 VERSION

Version 0.0.6

=cut

our $VERSION = '0.0.6';

__PACKAGE__->mk_acc_ref([ qw( _filename ) ]);

sub _init
{
    my ($self, $args) = @_;

    $self->_filename($args->{filename});

    return;
}

=head1 SYNOPSIS

See HTML::Widgets::NavMenu::ToJSON .

=head1 DESCRIPTION

This is a sub-class of L<HTML::Widgets::NavMenu::ToJSON::Data_Persistence>
for providing coarse-grained persistence using a serialised YAML store as
storage.

=head1 SUBROUTINES/METHODS

=head2 HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML->new({ filename => '/path/to/filename.yml' });

Initializes the persistence store with the YAML file in $args->{filename} .

=cut

=head2 $self->load()

Loads the data from the file.

=cut

sub load
{
    my $self = shift;

    my $data;

    if (!eval
    {
        ($data) = YAML::XS::LoadFile($self->_filename());

        1;
    })
    {
        $data = $self->_calc_initial_data();
    }

    $self->_data(
        $data
    );

    return;
}

=head2 $self->save()

Saves the data from the file.

=cut

sub save
{
    my $self = shift;

    YAML::XS::DumpFile(
        $self->_filename,
        $self->_data
    );

    return;
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-widgets-navmenu-tojson at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-Widgets-NavMenu-ToJSON>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML


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

1; # End of HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML

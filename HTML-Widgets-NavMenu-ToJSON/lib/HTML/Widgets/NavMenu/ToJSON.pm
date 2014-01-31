package HTML::Widgets::NavMenu::ToJSON;

use 5.008;
use strict;
use warnings FATAL => 'all';

use Carp;

use parent 'HTML::Widgets::NavMenu::Object';

use JSON qw(encode_json);

=head1 NAME

HTML::Widgets::NavMenu::ToJSON - convert HTML::Widgets::NavMenu to JSON

=head1 VERSION

Version 0.0.2

=cut

our $VERSION = '0.0.2';

=head1 SYNOPSIS

    use HTML::Widgets::NavMenu::ToJSON;
    use HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML;

    my $persistence =
        HTML::Widgets::NavMenu::ToJSON::Data_Persistence::YAML->new(
            {
                filename => '/path/to/persistence_data.yaml',
            }
        );

    my $obj = HTML::Widgets::NavMenu::ToJSON->new(
        {
            data_persistence_store => $persistence,
            # The one given as input to HTML::Widgets::NavMenu
            tree_contents => $tree_contents,
        }
    );

    use IO::All;

    io->file('output.json')->println(
        $obj->output_as_json(
            {
                %args
            }
        )
    );

=head1 SUBROUTINES/METHODS

=cut

__PACKAGE__->mk_acc_ref(
    [
        qw(
        _data_persistence_store
        _tree_contents
        ),
    ]
);

sub _init
{
    my ($self, $args) = @_;

    $self->_data_persistence_store(
        $args->{'data_persistence_store'}
    ) or Carp::confess("No data_persistence_store specified.");

    $self->_tree_contents(
        $args->{'tree_contents'}
    ) or Carp::confess("No tree_contents specified.");

    return;
}

sub _get_id_for_url
{
    my ($self, $url) = @_;
    return $self->_data_persistence_store->get_id_for_url($url);
}

=head2 $self->output_as_json()

=cut

sub output_as_json
{
    my $self = shift;

    my $persistence = $self->_data_persistence_store();

    $persistence->load;

    my $process_sub_tree;

    $process_sub_tree = sub
    {
        my ($sub_tree) = @_;

        my @keys = (grep { $_ ne 'subs' } keys %{$sub_tree});

        my $has_subs = exists($sub_tree->{subs});

        return
        {
            (exists($sub_tree->{url})
                ? (id => $self->_get_id_for_url($sub_tree->{url}), )
                : ()
            ),
            (map { $_ => $sub_tree->{$_} } @keys),
            $has_subs
            ?  (subs => [ map { $process_sub_tree->($_) }
                    grep { ! exists($_->{separator}) }
                    @{$sub_tree->{subs}}
                ])
            : (),
        };
    };

    my $ret = encode_json(
        $process_sub_tree->($self->_tree_contents)->{'subs'}
    );

    $persistence->save;

    return $ret;
}

=head1 AUTHOR

Shlomi Fish, C<< <shlomif at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-html-widgets-navmenu-tojson at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTML-Widgets-NavMenu-ToJSON>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTML::Widgets::NavMenu::ToJSON


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

1; # End of HTML::Widgets::NavMenu::ToJSON

package HTML::Widgets::NavMenu::Object;

use strict;
use warnings;

use base 'Class::Accessor';

sub new
{
    my $class = shift;
    my $self = {};
    
    bless($self, $class);
    
    $self->_init(@_);
    
    return $self;
}

sub _init
{
    my $self = shift;

    return 0;
}

sub destroy_
{
    my $self = shift;
    
    return 0;
}

sub DESTROY
{
    my $self = shift;
    
    $self->destroy_();
}

=head1 NAME

HTML::Widgets::NavMenu::Object - a base object for HTML::Widgets::NavMenu

=head1 SYNOPSIS

For internal use only

=head1 FUNCTIONS

=head2 my $obj = HTML::Widgets::NavMenu::Object->new(@args)

Instantiates a new object. Calls C<$obj-E<gt>_init()> with C<@args>.

=head2 my $obj = HTML::Widgets::NavMenu::Object->destroy_();

A method that can be used to explicitly destroy an object.

=head1 COPYRIGHT & LICENSE

Copyright 2006 Shlomi Fish, all rights reserved.

This program is released under the following license: MIT X11.

=cut

1;

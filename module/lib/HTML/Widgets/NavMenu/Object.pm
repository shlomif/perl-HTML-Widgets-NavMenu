package HTML::Widgets::NavMenu::Object;

use strict;
use warnings;

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

1;

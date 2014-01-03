package App::Dancecard::Doc;

use 5.10.0;

use strict;
use warnings;

use MooseX::App::Command;

extends 'App::Dancecard';

parameter 'doc_libs' => (
    traits => [ 'Array' ],
    is => 'ro',
    isa => 'ArrayRef[Str]',
    required => 0,
    default => sub { [] },
    handles => {
        all_to_peruse => 'elements',
        add_to_peruse => 'push',
    },
);

has "browser_command" => (
    isa => 'Str',
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;

        return $self->_config_data->{browser_command} 
            || 'firefox %s';
    },
);

option installed => (
    isa => 'Bool',
    is => 'ro',
);

sub run {
    my $self = shift;

    my $libs = $self->libs;

    if( $self->installed ) {
        $self->add_to_peruse( $_->{name} ) for 
            $self->installed_libs;
    }

    for my $l ( $self->all_to_peruse ) {
        my $location = $libs->{$l}{documentation} or do {
            warn "no documentation url found for $l\n";
            next;
        };
        system sprintf $self->browser_command, $location;
    }
}

1;






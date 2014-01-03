package App::Dancecard::List;

use 5.10.0;

use strict;
use warnings;

use MooseX::App::Command;

extends 'App::Dancecard';

sub run {
    my $self = shift;

    $self->print_installed_libs;

    $self->print_non_installed_libs;
}

sub print_installed_libs {
    my $self = shift;
   
    my @installed = $self->installed_libs;

    say "INSTALLED LIBS";

    unless ( @installed ) {
        say "no lib installed";
        return;
    }

    say "\t", $_->{name} for @installed;
}

sub print_non_installed_libs {
    my $self = shift;
   
    my @installed = $self->non_installed_libs;

    say "AVAILABLE LIBS";

    unless ( @installed ) {
        say "no lib available";
        return;
    }

    say "\t", $_->{name} for @installed;
}


1;

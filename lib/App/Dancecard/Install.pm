package App::Dancecard::Install;

use 5.10.0;

use strict;
use warnings;

use MooseX::App::Command;

extends 'App::Dancecard';

parameter 'to_install' => (
    traits => [ 'Array' ],
    is => 'ro',
    isa => 'ArrayRef[Str]',
    required => 1,
    handles => {
        all_to_install => 'elements',
    },
);

sub install {
    my( $self, $lib ) = @_;

    my $dest = $self->lib_dir->child($lib->{name});
    $dest->mkpath;

    my $location = $lib->{location};

    # right now, only one file
    use LWP::Simple qw/ getstore /;
    my $file = $location;
    $file =~ s#^.*/##;

    getstore( $location, $dest->child($file)->stringify );
}

sub run {
    my $self = shift;

    my @deps = $self->all_to_install;
    my $libs = $self->libs;

    DEP:
    while ( my $next = shift @deps ) {
        my $lib = $libs->{$next} or do {
            warn "$next is not a recognized library, skipping\n";
            next DEP;
        };

        if( $lib->{installed} ) {
            warn "$next is already present, skipping\n";
            next DEP;
        }

        $self->install($lib);

        say "$next installed";

        if ( my $deps = $lib->{dependencies} ) {
            push @deps, grep { not $self->libs->{$_}{installed} } @$deps;
        }

    }

}

1;




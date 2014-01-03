package App::Dancecard;

use 5.10.0;

use strict;
use warnings;

use MooseX::App qw/ ConfigHome /;

use MooseX::Types::Path::Tiny qw/Path/;

option lib_dir => (
    is => 'ro',
    isa => Path,
    coerce => 1,
    default => './public/lib',
);

has "libs" => (
    isa => 'HashRef',
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;

        return $self->has_config_data ? $self->_config_data->{libs} : {};
    },
);

sub BUILD {
    my $self = shift;

    while( my($k,$v) = each %{ $self->libs } ) {
        $v->{name} = $k;
        $v->{installed} = $self->lib_dir->child($k)->is_dir 
    }
}


sub installed_libs {
    my $self = shift;

    return grep { $_->{installed} } values %{ $self->libs };
}

sub non_installed_libs {
    my $self = shift;

    return grep { not $_->{installed} } values %{ $self->libs };
}

1;

__END__

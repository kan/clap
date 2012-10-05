package Clap;
use strict;
use warnings;
use 5.010001;
our $VERSION = '0.01';

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(app);

use UNIVERSAL::can;

sub app {
    my $pkg = shift;

    sub {
        my $env = shift;

        my ($method,) = grep { $_ } split(qr{/}, $env->{PATH_INFO}||'');
        $method ||= 'index'; # default
        if ($pkg->can($method)) {
            return [
                200,
                [ 'Content-Type' => 'text/html' ],
                [ $pkg->$method($env) ]
            ];
        } else {
            return [
                404,
                [ 'Content-Type' => 'text/html' ],
                [ "Not Found" ]
            ];
        }
    };
}


1;
__END__

=encoding utf8

=head1 NAME

Clap - A module for you

=head1 SYNOPSIS

  use Clap;

=head1 DESCRIPTION

Clap is

=head1 AUTHOR

Kan Fushihara E<lt>kan.fushihara@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

Copyright (C) Kan Fushihara

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

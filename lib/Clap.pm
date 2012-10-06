package Clap;
use strict;
use warnings;
use 5.010001;
our $VERSION = '0.01';

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(app);

our $FAVICON_IMG;

use UNIVERSAL::can;
use MIME::Base64;

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
        } elsif ($method eq 'favicon.ico') {
            unless ($FAVICON_IMG) {
                my @img = qw(
                  iVBORw0KGgoAAAANSUhEUgAAACAAAAAgEAYAAAAj6qa3AAAABmJLR0T///////8JWPfcAAAACXBI
                  WXMAAABIAAAASABGyWs+AAACV0lEQVRo3mP8DwUMBMCnqd/rXlsyMNy3eZV8rgG3OmlzIS+NmQwM
                  Ij94r8qvw63uq8lPi/d6DAx35r5YeaqbkO0MDBK+AnHKRgwMLzZ/WHT3HG51ikfE5ho1MDDwZXM2
                  iR4nbC4TYSW0Adxn2E8IXmJgkCkXktOqGyhXDGAAwIDwDl5G2ZMDFxADHgADHRCDJgAGKiBYYIUb
                  IfD7zN+JP5QZGBhsGJLpGRAMHgxyDOYMDH8i/ln9soJKehB256ep3xmI8RfjhQsPHuzYQbgWIBYQ
                  WwuQCt6wf9Z+GMjA8PTUu203Mqhn7qDLAvQGowEw0A4YaMAi4SsQp2xMhMpIBmvGNgYG5olMG1ke
                  4FbGfpJVmecw9R3KfopVmecItIxhpJ65RBeCsGoJXjoPE0AwCwxXjxMMgOHucZwBMFI8jhEAI83j
                  sO44wxfjH+bvdP+PGPDG/dO/R2b//8MKf0ZiB0SGOnjr8fn/Y3MGhied7x5da0KID/uGEC6PD/sA
                  IOTxYRsAxHocBhhfs33SehBAvTIA1mTl1efYJPyaeh77fOGH31tRBoaf5r/vfrHBre5v/j+/PwoM
                  DAwrGI79ryJsLgu1+9ewtjrvDw4GYeoZC/c40e6NZshgOEdY2bDLAqSC0QAYaAcMNGCBzaQQArDB
                  xicFby9di8Wt7m/+P/8/CojSmN5Na5kJwnpaixkYWE2Y8znuEhEAxE4hETvKyrCc4ej/KgaGJ5vf
                  Pbp2lgE+qkuvgIB5fNBMjcHqY1iKGGyAbmXAYA0IuheCgy0gBqwWgAUEvF8+QAAAsgEc0GxVvKMA
                  AAAASUVORK5CYIIo=
                );
                $FAVICON_IMG = decode_base64(join("\n",@img));
            }
            return [
                200,
                [ 'Content-Type' => 'image/png' ],
                [ $FAVICON_IMG ]
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

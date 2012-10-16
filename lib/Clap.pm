package Clap;
use strict;
use warnings;
use 5.010001;
our $VERSION = '0.01';

use Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(app req);

our $FAVICON_IMG;

use UNIVERSAL::can;
use MIME::Base64;
use PadWalker qw(var_name);
use Plack::Request;
use JSON;
use Data::Section::Simple;

sub _response {
    my ($pkg, $data) = @_;

    if (ref($data) && ref($data) eq 'HASH') {
        return [
            200,
            [ 'Content-Type' => 'application/javascript' ],
            [ JSON::encode_json($data) ]
        ];
    }
    else {
        my $app_data = Data::Section::Simple->new($pkg)->get_data_section;
        my $clap_data = Data::Section::Simple->new("Clap")->get_data_section;
        my $html = $app_data ? $app_data->{main} || $clap_data->{main} : $clap_data->{main};
        $html =~ s/{% body %}/$data/;
        return [
            200,
            [ 'Content-Type' => 'text/html' ],
            [ $html ]
        ];
    }
}

sub app {
    my $pkg = shift;

    sub {
        my $env = shift;

        my ($method,) = grep { $_ } split(qr{/}, $env->{PATH_INFO}||'');
        $method ||= 'index'; # default
        if ($pkg->can($method)) {
            _response($pkg, $pkg->$method($env));
        } 
        elsif ($method eq 'favicon.ico') {
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

sub req {
    {
        package DB;
        () = caller(1);
    }

    if ((var_name(1, \$_[0]) || '') =~ /^\$(self|class)$/) {
        $_[0] = shift @DB::args;
        shift;
    } 
    else {
        shift @DB::args; # drop package
    }

    my $env = shift @DB::args;
    my $req = Plack::Request->new($env);
    if ((var_name(1, \$_[0]) || '') =~ /^\$(req|request)$/) {
        $_[0] = $req;
        shift;
    }

    for (my $i = 0; $i < scalar(@_); $i++) {
        (my $name = var_name(1, \$_[$i]))
            or Carp::croak('usage: req my $param');

        $name =~ s/^\$//;
        $_[$i] = $req->param($name);
    }
}



1;

__DATA__
@@ main
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
    <title>clap sample</title>
</head>
<body>
{% body %}
</body>
</html>

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


package App;

use lib 'lib';
use Clap;

sub sum {
    req my $req, my $x, my $y;

    return { result => ($x + $y) };
}

__PACKAGE__->app;

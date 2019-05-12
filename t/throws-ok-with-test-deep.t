#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::Deep;

BEGIN { use_ok( 'Test::Exception' ) };

throws_ok
    { die Local::Error->new( code => 404, message => 'Not Found' ) }
    all(
        obj_isa( 'Local::Error' ),
        methods(
            code => 404,
            message => re( qr/found/i ),
        ),
    ),
    'should recognize Test::Deep::Cmp expectation'
    ;

package
    Local::Error;

sub new {
    my ( $class, %params ) = @_;

    bless \%params, $class;
}

sub code {
    $_[0]->{code};
}

sub message {
    $_[0]->{message};
}


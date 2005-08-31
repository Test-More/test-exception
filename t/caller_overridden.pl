#! /usr/bin/perl

use strict;
use warnings;

our $Ran_our_caller = 0;

BEGIN {
    *CORE::GLOBAL::caller = sub (;$) {
        my $level = shift;
        $level=0 unless defined $level;
        $level++;
        $Ran_our_caller = 1;
        package DB;
        return CORE::caller( $level );
    };
}
use Test::More tests => 3;

BEGIN { use_ok ( 'Test::Exception' ) };

throws_ok { die caller() . "\n" }  qr/^main$/, 'our caller wrapping works';

ok( $Ran_our_caller, 'we correctly wrap existing overridden caller' );

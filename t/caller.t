#!/usr/bin/perl -Tw

# Make sure caller() is undisturbed.

use strict;
use Test::More 'no_plan';

BEGIN {use_ok('Test::Exception')};

sub die_with_package {
    die scalar caller();
};

eval { die_with_package() };
like( $@, qr/^main/, 'call without T::E returns package main' );
throws_ok { die_with_package() }  qr/^main/, 'die with T::E returns package main';


sub die_with_caller {
	my $subroutine = (caller(1))[3];
	die $subroutine;
}

eval { die_with_caller() };
like( $@, qr/eval/, 'call without T::E returns package main' );
throws_ok { die_with_caller() } qr/eval/, 'expected eval';

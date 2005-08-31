#!/usr/bin/perl -Tw

# Make sure caller() is undisturbed.

use strict;
use Test::Exception;
use Test::More tests => 2;


eval { die caller() . "\n" };
is( $@, "main\n" );

throws_ok { die caller() . "\n" }  qr/^main$/;

{  package Foo;
    use Carp qw(confess);
    sub an_abstract_method { shift->subclass_responsibility; }
    sub subclass_responsibility {
        my $class  = shift;
        my $method = (caller(1))[3];
        $method    =~ s/.*:://;
        confess( "abstract method '$method' not implemented for $class" );
    }
}

#throws_ok { Foo->an_abstract_method } qr/abstract method 'an_abstract_method'/;

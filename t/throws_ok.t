#! /usr/bin/perl -Tw

use strict;
use warnings;
use Test::Builder;
use Test::Harness;
use Test::Builder::Tester tests => 4;
use Test::More;

BEGIN { use_ok( 'Test::Exception' ) };

eval { throws_ok {} undef };
like( $@, '/^throws_ok/', 'cannot pass undef to throws_ok' );

{
  test_out('not ok 1 - threw Regexp ((?^:Correct output from not throwing in a throws_ok))');
  test_fail( +1 );
  my $ok = throws_ok { 1 } qr/Correct output from not throwing in a throws_ok/;
  test_test(name => 'Correct output from not throwing in a throws_ok', skip_err => 1);

  ok(!$ok, 'Fail if you don\'t throw in a throws_ok');
}

done_testing;

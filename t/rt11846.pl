#! /usr/bin/perl

use strict;
use warnings;

our $DEBUG;

# Sub::Uplevel

BEGIN {
    
    {   package My::Eval;
        use base qw( Exporter );
        our @EXPORT = ( 'my_eval' );
        
        sub _try_as_caller {
            my $coderef = shift;
            eval { $coderef->() };
            return $@;
        }
        
        sub my_eval (&) {
            my $coderef = shift;
            return _try_as_caller( $coderef );
        }
    
        *CORE::GLOBAL::caller = sub (;$) {
            my $level = shift;
            $level=0 unless defined $level;
            $level++;
                    
            my $skip_start = 0;
            $skip_start++ 
                while CORE::caller( $skip_start ) 
                && CORE::caller( $skip_start ) ne __PACKAGE__;
            
            my $skip_end = $skip_start;
            $skip_end++ 
                while CORE::caller($skip_end) 
                && CORE::caller( $skip_end ) eq __PACKAGE__;
                
            my $skip_length = $skip_end - $skip_start;
                
            print "level = $level\n" if $DEBUG;
            print "skip_start = $skip_start\n" if $DEBUG;
            print "skip_end = $skip_end\n" if $DEBUG;
            print "skip_length = $skip_length\n" if $DEBUG;
            
            if ($level >= $skip_start) {
#                $level += $skip_length;
            };
            
            package DB;
            return CORE::caller( $level );
        };
    }    
}

BEGIN {
    
    {   package Foo;
        use Carp qw(confess);
        
        sub foo { shift->bar }
    
        sub bar {
            my $level = 0;
            {   package DB;
                while (my @info = (caller( $level ))[0,1,2,3] ) {
                    print "$level: ",             
                        join(' - ', map { defined $_ ? $_ : 'undef' } @info), "(@DB::args)\n";
                    $level++;
                }
            }
           my $method = (caller(1))[3];
           confess "$method\n";
die "$method\n";
         }
    
    }
    My::Eval->import;
}



eval { Foo->foo };
print "eval exception was: $@\n\n";

{
local $DEBUG = 0;
my $e = my_eval { Foo->foo };
print "my_eval exception was: $e\n";
}

print "done\n";

END {
    print "exit value is $?\n";
}
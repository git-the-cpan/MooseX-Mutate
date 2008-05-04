#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::Mutate' );
}

diag( "Testing MooseX::Mutate $MooseX::Mutate::VERSION, Perl $], $^X" );

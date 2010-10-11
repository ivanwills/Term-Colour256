#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1 + 1;
use Test::NoWarnings;

BEGIN {
	use_ok( 'Term::Colour256' );
}

diag( "Testing Term::Colour256 $Term::Colour256::VERSION, Perl $], $^X" );

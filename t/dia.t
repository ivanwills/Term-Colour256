#!/usr/bin/perl

BEGIN { $ENV{TESTING} = 1 }

use strict;
use warnings;
use Test::More tests => 4;

my $module = 'Term::Colour256';
use_ok( $module );


my $obj = $module->new();

ok( defined $obj, "Check that the class method new returns something" );
ok( $obj->isa('Term::Colour256'), " and that it is a Term::Colour256" );

can_ok( $obj, 'method',  " check object can execute method()" );
ok( $obj->method(),      " check object method method()" );
is( $obj->method(), '?', " check object method method()" );

ok( $Term::Colour256::func(),      " check method func()" );
is( $Term::Colour256::func(), '?', " check method func()" );

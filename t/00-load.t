#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Document::Presentation' );
}

diag( "Testing Document::Presentation $Document::Presentation::VERSION, Perl $], $^X" );

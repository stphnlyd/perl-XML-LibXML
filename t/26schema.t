# $Id$

##
# Testcases for the XML Schema interface
#

use Test;
use strict;

BEGIN { plan tests => 6 };

use XML::LibXML;

my $xmlparser = XML::LibXML->new();

my $file         = "test/schema/schema.xsd";
my $badfile      = "test/schema/badschema.xsd";
my $validfile    = "test/schema/demo.xml";
my $invalidfile  = "test/schema/invaliddemo.xml";


print "# 1 parse schema from a file\n";
{
    my $rngschema = XML::LibXML::Schema->new( location => $file );
    ok ( $rngschema );
    
    eval { $rngschema = XML::LibXML::Schema->new( location => $badfile ); };
    ok( $@ );
}

print "# 2 parse schema from a string\n";
{
    open RNGFILE, "<$file";
    my $string = join "", <RNGFILE>;
    close RNGFILE;

    my $rngschema = XML::LibXML::Schema->new( string => $string );
    ok ( $rngschema );

    open RNGFILE, "<$badfile";
    $string = join "", <RNGFILE>;
    close RNGFILE;
    eval { $rngschema = XML::LibXML::Schema->new( string => $string ); };
    ok( $@ );
}

print "# 3 validate a document\n";
{
    my $doc       = $xmlparser->parse_file( $validfile );
    my $rngschema = XML::LibXML::Schema->new( location => $file );

    my $valid = 0;
    eval { $valid = $rngschema->validate( $doc ); };
    ok( $valid, 0 );

    $doc       = $xmlparser->parse_file( $invalidfile );
    $valid     = 0;
    eval { $valid = $rngschema->validate( $doc ); };
    ok ( $@ );
}

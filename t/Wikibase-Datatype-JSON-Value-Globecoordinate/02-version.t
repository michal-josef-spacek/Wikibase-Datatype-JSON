use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Globecoordinate;

# Test.
is($Wikibase::Datatype::JSON::Value::Globecoordinate::VERSION, 0.01, 'Version.');

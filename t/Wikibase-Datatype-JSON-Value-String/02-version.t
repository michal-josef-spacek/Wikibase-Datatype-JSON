use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::String;

# Test.
is($Wikibase::Datatype::JSON::Value::String::VERSION, 0.01, 'Version.');

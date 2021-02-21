use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Quantity;

# Test.
is($Wikibase::Datatype::JSON::Value::Quantity::VERSION, 0.01, 'Version.');

use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Time;

# Test.
is($Wikibase::Datatype::JSON::Value::Time::VERSION, 0.01, 'Version.');

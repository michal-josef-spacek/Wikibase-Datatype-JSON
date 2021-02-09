use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON;

# Test.
is($Wikibase::Datatype::JSON::VERSION, 0.01, 'Version.');

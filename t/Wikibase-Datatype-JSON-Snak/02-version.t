use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Snak;

# Test.
is($Wikibase::Datatype::JSON::Snak::VERSION, 0.01, 'Version.');

use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Reference;

# Test.
is($Wikibase::Datatype::JSON::Reference::VERSION, 0.01, 'Version.');

use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Statement;

# Test.
is($Wikibase::Datatype::JSON::Statement::VERSION, 0.01, 'Version.');

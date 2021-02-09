use strict;
use warnings;

use Test::More 'tests' => 3;
use Test::NoWarnings;

BEGIN {

	# Test.
	use_ok('Wikibase::Datatype::JSON::Value::Item');
}

# Test.
require_ok('Wikibase::Datatype::JSON::Value::Item');

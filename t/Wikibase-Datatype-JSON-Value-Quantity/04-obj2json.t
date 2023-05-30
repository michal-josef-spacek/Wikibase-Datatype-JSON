use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 8;
use Test::NoWarnings;
use Wikibase::Datatype::Value::Quantity;
use Wikibase::Datatype::JSON::Value::Quantity;

# Test.
my $obj = Wikibase::Datatype::Value::Quantity->new(
	'value' => 10,
);
my $json = Wikibase::Datatype::JSON::Value::Quantity::obj2json($obj,
	{'base_uri' => 'https://test.wikidata.org/entity'});
my $right_json = <<'END';
{
  "value": {
    "amount": "+10",
    "unit": "1"
  },
  "type": "quantity"
}
END
cmp_json_types($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
$json = Wikibase::Datatype::JSON::Value::Quantity::obj2json(
	$obj,
	{
		'base_uri' => 'https://test.wikidata.org/entity',
		'pretty' => 1,
	}
);
$right_json = <<'END';
{
  "value": {
    "amount": "+10",
    "unit": "1"
  },
  "type": "quantity"
}
END
cmp_json_types($json, $right_json, 'Output of obj2json() subroutine (pretty print).');

# Test.
$obj = Wikibase::Datatype::Value::Quantity->new(
	'unit' => 'Q123',
	'value' => 10,
);
$json = Wikibase::Datatype::JSON::Value::Quantity::obj2json($obj,
	{'base_uri' => 'https://test.wikidata.org/entity/'});
$right_json = <<'END';
{
  "value": {
    "amount": "+10",
    "unit": "https://test.wikidata.org/entity/Q123"
  },
  "type": "quantity"
}
END
cmp_json_types($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Quantity->new(
	'lower_bound' => 9,
	'unit' => 'Q123',
	'value' => 10,
	'upper_bound' => 11,
);
$json = Wikibase::Datatype::JSON::Value::Quantity::obj2json($obj,
	{'base_uri' => 'https://test.wikidata.org/entity/'});
$right_json = <<'END';
{
  "value": {
    "amount": "+10",
    "lowerBound": "+9",
    "unit": "https://test.wikidata.org/entity/Q123",
    "upperBound": "+11"
  },
  "type": "quantity"
}
END
cmp_json_types($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Quantity::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::Quantity'.\n",
	"Object isn't 'Wikibase::Datatype::Value::Quantity'.");
clean();

# Test.
$obj = Wikibase::Datatype::Value::Quantity->new(
	'value' => 10,
);
eval {
	Wikibase::Datatype::JSON::Value::Quantity::obj2json($obj);
};
is($EVAL_ERROR, "Parameter 'base_uri' is required.\n",
	"Parameter 'base_uri' is required.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Quantity::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

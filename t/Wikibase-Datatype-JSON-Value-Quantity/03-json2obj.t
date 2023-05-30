use strict;
use warnings;

use Test::More 'tests' => 15;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Quantity;

# Test.
my $json = <<'END';
{
  "value": {
    "amount": "+10",
    "unit": "1"
  },
  "type": "quantity"
}
END
my $ret = Wikibase::Datatype::JSON::Value::Quantity::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Quantity');
is($ret->value, 10, 'Method value().');
is($ret->type, 'quantity', 'Method type().');
is($ret->unit, undef, 'Method unit().');

# Test.
$json = <<'END';
{
  "value": {
    "amount": "+10",
    "unit": "https://test.wikidata.org/entity/Q123"
  },
  "type": "quantity"
}
END
$ret = Wikibase::Datatype::JSON::Value::Quantity::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Quantity');
is($ret->value, 10, 'Method value().');
is($ret->type, 'quantity', 'Method type().');
is($ret->unit, 'Q123', 'Method unit().');

# Test.
$json = <<'END';
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
$ret = Wikibase::Datatype::JSON::Value::Quantity::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Quantity');
is($ret->value, 10, 'Method value().');
is($ret->type, 'quantity', 'Method type().');
is($ret->unit, 'Q123', 'Method unit().');
is($ret->lower_bound, 9, 'Method lower_bound().');
is($ret->upper_bound, 11, 'Method upper_bound().');

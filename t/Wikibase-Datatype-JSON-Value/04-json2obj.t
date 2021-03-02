use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 35;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikibase::Datatype::JSON::Value;

# Test.
my $json = <<'END';
{
   "value" : {
      "altitude" : null,
      "globe" : "http://test.wikidata.org/entity/Q111",
      "latitude" : 10.1,
      "longitude" : 20.1,
      "precision" : 1
   },
   "type" : "globecoordinate"
}
END
my $ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Globecoordinate');
is($ret->altitude, undef, 'Globecoordinate: Method altitude().');
is($ret->globe, 'Q111', 'Globecoordinate: Method globe().');
is($ret->latitude, 10.1, 'Globecoordinate: Method latitude().');
is($ret->longitude, 20.1, 'Globecoordinate: Method longitude().');
is($ret->precision, 1, 'Globecoordinate: Method precision().');
is($ret->type, 'globecoordinate', 'Globecoordinate: Method type().');
is_deeply($ret->value, [10.1, 20.1], 'Globecoordinate: Method value().');

# Test.
$json = <<'END';
{
  "value": {
    "entity-type": "item",
    "id": "Q497",
    "numeric-id": 497
  },
  "type": "wikibase-entityid"
}
END
$ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Item');
is($ret->value, 'Q497', 'Item: Method value().');
is($ret->type, 'item', 'Item: Method type().');

# Test.
$json = decode_utf8(<<'END');
{
  "value": {
    "language": "cs",
    "text": "Příklad"
  },
  "type": "monolingualtext"
}
END
$ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Monolingual');
is($ret->value, decode_utf8('Příklad'), 'Monolingual: Method value().');
is($ret->language, 'cs', 'Monolingual: Method language().');
is($ret->type, 'monolingualtext', 'Monolingual: Method type().');

# Test.
$json = <<'END';
{
  "value": {
    "entity-type": "property",
    "id": "P111",
    "numeric-id": 111
  },
  "type": "wikibase-entityid"
}
END
$ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Property');
is($ret->value, 'P111', 'Property: Method value().');
is($ret->type, 'property', 'Property: Method type().');

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
$ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Quantity');
is($ret->value, 10, 'Quantity: Method value().');
is($ret->unit, 'Q123', 'Quantity: Method unit().');
is($ret->type, 'quantity', 'Quantity: Method type().');

# Test.
$json = <<'END';
{
  "value": "Text",
  "type": "string"
}
END
$ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::String');
is($ret->value, 'Text', 'String: Method value().');
is($ret->type, 'string', 'String: Method type().');

# Test.
$json = <<'END';
{
   "type" : "time",
   "value" : {
      "after" : 0,
      "before" : 0,
      "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
      "precision" : 11,
      "time" : "+2020-09-01T00:00:00Z",
      "timezone" : 0
   }
}
END
$ret = Wikibase::Datatype::JSON::Value::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Time');
is($ret->after, 0, 'Time: Method after().');
is($ret->before, 0, 'Time: Method before().');
is($ret->calendarmodel, 'Q1985727', 'Time: Method calendarmodel().');
is($ret->precision, 11, 'Time: Method precision().');
is($ret->timezone, 0, 'Time: Method timezone().');
is($ret->type, 'time', 'Time: Method type().');
is($ret->value, '+2020-09-01T00:00:00Z', 'Time: Method value().');

# Test.
$json = <<'END';
{
  "value": {},
  "type": "bad"
}
END
eval {
	Wikibase::Datatype::JSON::Value::json2obj($json);
};
is($EVAL_ERROR, "Type 'bad' is unsupported.\n", "Type 'bad' is unsupported.");
clean();

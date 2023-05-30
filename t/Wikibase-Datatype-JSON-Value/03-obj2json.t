use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 11;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikibase::Datatype::Value::Globecoordinate;
use Wikibase::Datatype::Value::Item;
use Wikibase::Datatype::Value::Monolingual;
use Wikibase::Datatype::Value::Property;
use Wikibase::Datatype::Value::Quantity;
use Wikibase::Datatype::Value::String;
use Wikibase::Datatype::Value::Time;
use Wikibase::Datatype::JSON::Value;

# Test.
my $obj = Wikibase::Datatype::Value::Globecoordinate->new(
	'value' => [10.1, 20.1],
);
my $json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
});
my $right_json = <<'END';
{
   "value" : {
      "altitude" : null,
      "globe" : "http://test.wikidata.org/entity/Q2",
      "latitude" : 10.1,
      "longitude" : 20.1,
      "precision" : 1e-07
   },
   "type" : "globecoordinate"
}
END
cmp_json_types($json, $right_json, 'Globecoordinate: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Item->new(
	'value' => 'Q497',
);
$json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
});
$right_json = <<'END';
{
  "value": {
    "entity-type": "item",
    "id": "Q497",
    "numeric-id": 497
  },
  "type": "wikibase-entityid"
}
END
cmp_json_types($json, $right_json, 'Item: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Monolingual->new(
	'language' => 'cs',
	'value' => decode_utf8('Příklad.'),
);
$json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
});
$right_json = decode_utf8(<<'END');
{
  "value": {
    "language": "cs",
    "text": "Příklad"
  },
  "type": "monolingualtext"
}
END
cmp_json_types($json, $right_json, 'Monolingual: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Property->new(
	'value' => 'P123',
);
$json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
$right_json = <<'END';
{
  "value": {
    "entity-type": "property",
    "id": "P111",
    "numeric-id": 111
  },
  "type": "wikibase-entityid"
}
END
cmp_json_types($json, $right_json, 'Property: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Quantity->new(
	'unit' => 'Q123',
	'value' => 10,
);
$json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
$right_json = <<'END';
{
  "value": {
    "amount": "+10",
    "unit": "https://test.wikidata.org/entity/Q123"
  },
  "type": "quantity"
}
END
cmp_json_types($json, $right_json, 'Quantity: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::String->new(
	'value' => 'Text',
);
$json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
});
$right_json = <<'END';
{
  "value": "Text",
  "type": "string"
}
END
cmp_json_types($json, $right_json, 'String: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Time->new(
	'value' => '+2020-09-01T00:00:00Z',
);
$json = Wikibase::Datatype::JSON::Value::obj2json($obj, {
	'base_uri' => 'https://www.wikidata.org/entity/',
});
$right_json = <<'END';
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
cmp_json_types($json, $right_json, 'Time: Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value->new(
	'value' => 'text',
	'type' => 'bad',
);
eval {
	Wikibase::Datatype::JSON::Value::obj2json($obj, {
		'base_uri' => 'http://test.wikidata.org/entity/',
	});
};
is($EVAL_ERROR, "Type 'bad' is unsupported.\n",
	"Type 'bad' is unsupported.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::obj2json('bad', {
		'base_uri' => 'http://test.wikidata.org/entity/',
	});
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value'.\n",
	"Object isn't 'Wikibase::Datatype::Value'.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

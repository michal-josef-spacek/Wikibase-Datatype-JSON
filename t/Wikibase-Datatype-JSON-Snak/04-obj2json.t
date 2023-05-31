use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 7;
use Test::NoWarnings;
use Wikibase::Datatype::Snak;
use Wikibase::Datatype::Value::String;
use Wikibase::Datatype::JSON::Snak;

# Test.
my $obj = Wikibase::Datatype::Snak->new(
	'datatype' => 'string',
	'datavalue' => Wikibase::Datatype::Value::String->new(
		'value' => '1.1',
	),
	'property' => 'P11',
);
my $ret = Wikibase::Datatype::JSON::Snak::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
my $expected = <<'END';
{
  "datavalue":{
    "type":"string",
    "value":"1.1"
  },
  "snaktype":"value",
  "property":"P11",
  "datatype":"string"
}
END
cmp_json_types($ret, $expected, 'Serialization of Snak (value).');

# Test.
$obj = Wikibase::Datatype::Snak->new(
	'datatype' => 'string',
	'property' => 'P11',
	'snaktype' => 'novalue',
);
$ret = Wikibase::Datatype::JSON::Snak::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
$expected = <<'END';
{
  "snaktype":"novalue",
  "property":"P11",
  "datatype":"string"
}
END
cmp_json_types($ret, $expected, 'Serialization of Snak (novalue).');

# Test.
$obj = Wikibase::Datatype::Snak->new(
	'datatype' => 'string',
	'property' => 'P11',
	'snaktype' => 'somevalue',
);
$ret = Wikibase::Datatype::JSON::Snak::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
$expected = <<'END';
{
  "snaktype":"somevalue",
  "property":"P11",
  "datatype":"string"
}
END
cmp_json_types($ret, $expected, 'Serialization of Snak (somevalue).');

# Test.
eval {
	Wikibase::Datatype::JSON::Snak::obj2json('bad', {
		'base_uri' => 'http://test.wikidata.org/entity/',
	});
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Snak'.\n",
	"Object isn't 'Wikibase::Datatype::Snak'.");
clean();

# Test.
$obj = Wikibase::Datatype::Snak->new(
	'datatype' => 'string',
	'datavalue' => Wikibase::Datatype::Value::String->new(
		'value' => '1.1',
	),
	'property' => 'P11',
);
eval {
	Wikibase::Datatype::JSON::Snak::obj2json($obj);
};
is($EVAL_ERROR, "Parameter 'base_uri' is required.\n",
	"Parameter 'base_uri' is required.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Snak::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

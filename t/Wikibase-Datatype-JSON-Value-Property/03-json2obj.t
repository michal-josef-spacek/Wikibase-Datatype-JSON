use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 8;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Property;

# Test.
my $json = <<'END';
{
  "value": {
    "numeric-id": 111,
    "entity-type": "property",
    "id": "P111"
  },
  "type": "wikibase-entityid"
}
END
my $ret = Wikibase::Datatype::JSON::Value::Property::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Property');
is($ret->value, 'P111', 'Method value().');
is($ret->type, 'property', 'Method type().');

# Test.
$json = '{}';
eval {
	Wikibase::Datatype::JSON::Value::Property::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'property' datatype.\n",
	"Structure isn't for 'property' datatype (no type).");
clean();

# Test.
$json = <<'END';
{
  "type" : "bad"
}
END
eval {
	Wikibase::Datatype::JSON::Value::Property::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'property' datatype.\n",
	"Structure isn't for 'property' datatype (bad type).");
clean();

# Test.
$json = <<'END';
{
  "type" : "wikibase-entityid"
}
END
eval {
	Wikibase::Datatype::JSON::Value::Property::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'property' datatype.\n",
	"Structure isn't for 'property' datatype (no value/entity-type).");
clean();

# Test.
$json = <<'END';
{
  "type" : "wikibase-entityid",
  "value" : {
    "entity-type" : "bad"
  }
}
END
eval {
	Wikibase::Datatype::JSON::Value::Property::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'property' datatype.\n",
	"Structure isn't for 'property' datatype (bad value/entity-type).");
clean();

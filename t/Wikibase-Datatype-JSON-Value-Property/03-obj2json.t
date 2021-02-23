use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Wikibase::Datatype::Value::Property;
use Wikibase::Datatype::JSON::Value::Property;

# Test.
my $obj = Wikibase::Datatype::Value::Property->new(
	'value' => 'P111',
);
my $json = Wikibase::Datatype::JSON::Value::Property::obj2json($obj);
my $right_json = <<'END';
{
  "value": {
    "numeric-id": 111,
    "entity-type": "property",
    "id": "P111"
  },
  "type": "wikibase-entityid"
}
END
is_json_type($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Property->new(
	'value' => 'P111',
);
$json = Wikibase::Datatype::JSON::Value::Property::obj2json($obj, {'pretty' => 1});
$right_json = <<'END';
{
  "value": {
    "numeric-id": 111,
    "entity-type": "property",
    "id": "P111"
  },
  "type": "wikibase-entityid"
}
END
is_json_type($json, $right_json, 'Output of obj2json() subroutine (pretty print).');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Property::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::Property'.\n",
	"Object isn't 'Wikibase::Datatype::Value::Property'.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Property::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

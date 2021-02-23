use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Wikibase::Datatype::Value::Item;
use Wikibase::Datatype::JSON::Value::Item;

# Test.
my $obj = Wikibase::Datatype::Value::Item->new(
	'value' => 'Q497',
);
my $json = Wikibase::Datatype::JSON::Value::Item::obj2json($obj);
my $right_json = <<'END';
{
  "value": {
    "numeric-id": 497,
    "entity-type": "item",
    "id": "Q497"
  },
  "type": "wikibase-entityid"
}
END
is_json_type($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Item->new(
	'value' => 'Q497',
);
$json = Wikibase::Datatype::JSON::Value::Item::obj2json($obj, {'pretty' => 1});
$right_json = <<'END';
{
  "value": {
    "numeric-id": 497,
    "entity-type": "item",
    "id": "Q497"
  },
  "type": "wikibase-entityid"
}
END
is_json_type($json, $right_json, 'Output of obj2json() subroutine (pretty print).');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Item::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::Item'.\n",
	"Object isn't 'Wikibase::Datatype::Value::Item'.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Item::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

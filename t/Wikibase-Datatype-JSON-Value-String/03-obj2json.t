use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Wikibase::Datatype::Value::String;
use Wikibase::Datatype::JSON::Value::String;

# Test.
my $obj = Wikibase::Datatype::Value::String->new(
	'value' => 'Text',
);
my $json = Wikibase::Datatype::JSON::Value::String::obj2json($obj);
my $right_json = <<'END';
{
  "value": "Text",
  "type": "string"
}
END
is_json($json, $right_json, 'Output of obj2json() subroutine.');

# Test
$json = Wikibase::Datatype::JSON::Value::String::obj2json($obj);
$right_json = <<'END';
{
  "value": "Text",
  "type": "string"
}
END
is_json($json, $right_json, 'Output of obj2json() subroutine (pretty print).');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::String::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::String'.\n",
	"Object isn't 'Wikibase::Datatype::Value::String'.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::String::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

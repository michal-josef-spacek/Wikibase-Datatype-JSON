use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON;
use Test::More 'tests' => 6;
use Test::NoWarnings;
use Wikibase::Datatype::Value::Time;
use Wikibase::Datatype::JSON::Value::Time;

# Test.
my $obj = Wikibase::Datatype::Value::Time->new(
	'value' => '+2020-09-01T00:00:00Z',
);
my $json = Wikibase::Datatype::JSON::Value::Time::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
});
my $right_json = <<'END';
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
is_json($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
$json = Wikibase::Datatype::JSON::Value::Time::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
	'pretty' => 1,
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
is_json($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Time::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::Time'.\n",
	"Object isn't 'Wikibase::Datatype::Value::Time'.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Time::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

# Test.
$obj = Wikibase::Datatype::Value::Time->new(
	'value' => '+2020-09-01T00:00:00Z',
);
eval {
	Wikibase::Datatype::JSON::Value::Time::obj2json($obj);
};
is($EVAL_ERROR, "Parameter 'base_uri' is required.\n",
	"Parameter 'base_uri' is required.");
clean();

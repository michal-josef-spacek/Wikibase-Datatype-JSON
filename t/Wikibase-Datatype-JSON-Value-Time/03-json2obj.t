use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 11;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Time;

# Test.
my $json = <<'END';
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
my $ret = Wikibase::Datatype::JSON::Value::Time::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Time');
is($ret->after, 0, 'Method after().');
is($ret->before, 0, 'Method before().');
is($ret->calendarmodel, 'Q1985727', 'Method calendarmodel().');
is($ret->precision, 11, 'Method precision().');
is($ret->timezone, 0, 'Method timezone().');
is($ret->type, 'time', 'Method type().');
is($ret->value, '+2020-09-01T00:00:00Z', 'Method value().');

# Test.
$json = '{}';
eval {
	Wikibase::Datatype::JSON::Value::Time::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'time' datatype.\n",
	"Structure isn't for 'time' datatype.");
clean();

# Test.
$json = '{"type": "bad"}';
eval {
	Wikibase::Datatype::JSON::Value::Time::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'time' datatype.\n",
	"Structure isn't for 'time' datatype.");
clean();

use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 27;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Globecoordinate;

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
my $ret = Wikibase::Datatype::JSON::Value::Globecoordinate::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Globecoordinate');
is($ret->altitude, undef, 'Method altitude().');
is($ret->globe, 'Q111', 'Method globe().');
is($ret->latitude, 10.1, 'Method latitude().');
is($ret->longitude, 20.1, 'Method longitude().');
is($ret->precision, 1, 'Method precision().');
is($ret->type, 'globecoordinate', 'Method type().');
is_deeply($ret->value, [10.1, 20.1], 'Method value().');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Globecoordinate::json2obj('{}');
};
is($EVAL_ERROR, "Structure isn't for 'globecoordinate' datatype.\n",
	"No 'globecoordinate' structure.");
clean();

# Test.
$json = <<'END';
{
  "type": "bad"
}
END
eval {
	Wikibase::Datatype::JSON::Value::Globecoordinate::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'globecoordinate' datatype.\n",
	"No 'globecoordinate' structure.");
clean();

# Test.
$json = <<'END';
{
   "value" : {
      "altitude" : 100.0,
      "globe" : "http://test.wikidata.org/entity/Q111",
      "latitude" : 10.1,
      "longitude" : 20.1,
      "precision" : 1
   },
   "type" : "globecoordinate"
}
END
$ret = Wikibase::Datatype::JSON::Value::Globecoordinate::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Globecoordinate');
is($ret->altitude, 100, 'Method altitude().');
is($ret->globe, 'Q111', 'Method globe().');
is($ret->latitude, 10.1, 'Method latitude().');
is($ret->longitude, 20.1, 'Method longitude().');
is($ret->precision, 1, 'Method precision().');
is($ret->type, 'globecoordinate', 'Method type().');
is_deeply($ret->value, [10.1, 20.1], 'Method value().');

# Test.
$json = <<'END';
{
   "value" : {
      "altitude" : null,
      "globe" : "http://test.wikidata.org/entity/Q2",
      "latitude" : 51.566516666667,
      "longitude" : -0.14549722222222,
      "precision" : 2.7777777777778e-06
   },
   "type" : "globecoordinate"
}
END
$ret = Wikibase::Datatype::JSON::Value::Globecoordinate::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Globecoordinate');
is($ret->altitude, undef, 'Method altitude().');
is($ret->globe, 'Q2', 'Method globe().');
is($ret->latitude, 51.566516666667, 'Method latitude().');
is($ret->longitude, -0.14549722222222, 'Method longitude().');
is($ret->precision, 2.7777777777778e-06, 'Method precision().');
is($ret->type, 'globecoordinate', 'Method type().');
is_deeply($ret->value, [51.566516666667, -0.14549722222222], 'Method value().');

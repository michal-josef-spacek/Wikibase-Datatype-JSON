use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 7;
use Test::NoWarnings;
use Wikibase::Datatype::Value::Globecoordinate;
use Wikibase::Datatype::JSON::Value::Globecoordinate;

# Test.
my $obj = Wikibase::Datatype::Value::Globecoordinate->new(
	'value' => [10.1, 20.1],
);
my $json = Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json($obj, {
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
is_json_type($json, $right_json, 'Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Globecoordinate->new(
	'value' => [10.1, 20.1],
);
$json = Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
	'pretty' => 1,
});
$right_json = <<'END';
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
is_json_type($json, $right_json, 'Output of obj2json() subroutine (pretty print).');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::Globecoordinate'.\n",
	"Object isn't 'Wikibase::Datatype::Value::Globecoordinate'.");
clean();

# Test.
$obj = Wikibase::Datatype::Value::Globecoordinate->new(
	'altitude' => 100,
	'value' => [10.1, 20.1],
);
$json = Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json($obj, {
	'base_uri' => 'http://test.wikidata.org/entity/',
	'pretty' => 1,
});
$right_json = <<'END';
{
   "value" : {
      "altitude" : 100.0,
      "globe" : "http://test.wikidata.org/entity/Q2",
      "latitude" : 10.1,
      "precision" : 1e-07,
      "longitude" : 20.1
   },
   "type" : "globecoordinate"
}
END
is_json_type($json, $right_json, 'Output of obj2json() subroutine (with altitude).');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

# Test.
$obj = Wikibase::Datatype::Value::Globecoordinate->new(
	'altitude' => 100,
	'value' => [10.1, 20.1],
);
eval {
	Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json($obj);
};
is($EVAL_ERROR, "Parameter 'base_uri' is required.\n",
	"Parameter 'base_uri' is required.");
clean();

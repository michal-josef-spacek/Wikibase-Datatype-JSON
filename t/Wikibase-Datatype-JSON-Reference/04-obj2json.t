use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Test::Shared::Fixture::Wikibase::Datatype::Reference::Wikidata::ReferenceURL;
use Wikibase::Datatype::JSON::Reference;

# Test.
my $obj = Test::Shared::Fixture::Wikibase::Datatype::Reference::Wikidata::ReferenceURL->new;
my $ret = Wikibase::Datatype::JSON::Reference::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
my $expected = <<'END';
{
  "snaks":{
    "P854":[{
      "property":"P854",
      "datavalue":{
        "type":"string",
        "value":"https://skim.cz"
      },
      "snaktype":"value",
      "datatype":"url"
    }],
    "P813":[{
      "snaktype":"value",
      "datavalue":{
        "value":{
          "calendarmodel":"https://test.wikidata.org/entity/Q1985727",
          "time":"+2013-12-07T00:00:00Z",
          "precision":11,
          "after":0,
          "before":0,
          "timezone":0
        },
        "type":"time"
      },
      "property":"P813",
      "datatype":"time"
    }]
  },
  "snaks-order":[
    "P854",
    "P813"
  ]
}
END
cmp_json_types($ret, $expected, 'Serialization of Reference (value).');

# Test.
eval {
	Wikibase::Datatype::JSON::Reference::obj2json('bad', {
		'base_uri' => 'http://test.wikidata.org/entity/',
	});
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Reference'.\n",
	"Object isn't 'Wikibase::Datatype::Reference'.");
clean();

# Test.
$obj = Test::Shared::Fixture::Wikibase::Datatype::Reference::Wikidata::ReferenceURL->new;
eval {
	Wikibase::Datatype::JSON::Reference::obj2json($obj);
};
is($EVAL_ERROR, "Parameter 'base_uri' is required.\n",
	"Parameter 'base_uri' is required.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Reference::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

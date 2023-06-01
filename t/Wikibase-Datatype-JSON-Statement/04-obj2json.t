use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Test::Shared::Fixture::Wikibase::Datatype::Statement::Wikidata::InstanceOf::VersionEditionOrTranslation;
use Wikibase::Datatype::JSON::Statement;

# Test.
my $obj = Test::Shared::Fixture::Wikibase::Datatype::Statement::Wikidata::InstanceOf::VersionEditionOrTranslation->new;
my $ret = Wikibase::Datatype::JSON::Statement::obj2json($obj, {
	'base_uri' => 'https://test.wikidata.org/entity/',
});
my $expected = <<'END';
{
  "rank":"normal",
  "references":[{
    "snaks-order":[
      "P248",
      "P214",
      "P813"
    ],
    "snaks":{
      "P214":[{
        "datatype":"external-id",
        "datavalue":{
          "value":"113230702",
          "type":"string"
        },
        "snaktype":"value",
        "property":"P214"
      }],
      "P248":[{
        "property":"P248",
        "snaktype":"value",
        "datatype":"wikibase-item",
        "datavalue":{
          "value":{
            "id":"Q53919",
            "entity-type":"item",
            "numeric-id":53919
          },
          "type":"wikibase-entityid"
        }
      }],
      "P813":[{
        "snaktype":"value",
        "property":"P813",
        "datatype":"time",
        "datavalue":{
          "value":{
            "calendarmodel":"https://test.wikidata.org/entity/Q1985727",
            "timezone":0,
            "after":0,
            "precision":11,
            "time":"+2013-12-07T00:00:00Z",
            "before":0
          },
          "type":"time"
        }
      }]
    }
  }],
  "qualifiers":{
    "P642":[{
      "datavalue":{
        "type":"wikibase-entityid",
        "value":{
          "numeric-id":5185279,
          "entity-type":"item",
          "id":"Q5185279"
        }
      },
      "datatype":"wikibase-item",
      "property":"P642",
      "snaktype":"value"
    }]
  },
  "qualifiers-order":[
    "P642"
  ],
  "mainsnak":{
    "snaktype":"value",
    "property":"P31",
    "datatype":"wikibase-item",
    "datavalue":{
      "value":{
        "numeric-id":3331189,
        "entity-type":"item",
        "id":"Q3331189"
      },
      "type":"wikibase-entityid"
    }
  },
  "type":"statement"
}
END
cmp_json_types($ret, $expected, 'Serialization of Statement.');

# Test.
eval {
	Wikibase::Datatype::JSON::Statement::obj2json('bad', {
		'base_uri' => 'http://test.wikidata.org/entity/',
	});
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Statement'.\n",
	"Object isn't 'Wikibase::Datatype::Statement'.");
clean();

# Test.
$obj = Test::Shared::Fixture::Wikibase::Datatype::Statement::Wikidata::InstanceOf::VersionEditionOrTranslation->new;
eval {
	Wikibase::Datatype::JSON::Statement::obj2json($obj);
};
is($EVAL_ERROR, "Parameter 'base_uri' is required.\n",
	"Parameter 'base_uri' is required.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Statement::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

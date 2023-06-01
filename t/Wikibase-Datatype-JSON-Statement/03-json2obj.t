use strict;
use warnings;

use Test::More 'tests' => 9;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Statement;

# Test.
my $json = <<'END';
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
my $ret = Wikibase::Datatype::JSON::Statement::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Statement');
isa_ok($ret->snak, 'Wikibase::Datatype::Snak');
is($ret->rank, 'normal', 'Method rank().');
is(@{$ret->references}, 1, 'Count of references.');
is(@{$ret->references->[0]->snaks}, 3, 'Count of snaks in reference.');
is(@{$ret->property_snaks}, 1, 'Count of property snaks.');
is($ret->property_snaks->[0]->property, 'P642', 'Qualifier property.');
is($ret->property_snaks->[0]->datavalue->value, 'Q5185279', 'Qualifier datavalue.');

use strict;
use warnings;

use Test::More 'tests' => 10;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Reference;

# Test.
my $json = <<'END';
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
my $ret = Wikibase::Datatype::JSON::Reference::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Reference');
is($ret->snaks->[0]->property, 'P854', 'Get property.');
is($ret->snaks->[0]->datatype, 'url', 'Get datatype.');
isa_ok($ret->snaks->[0]->datavalue, 'Wikibase::Datatype::Value::String');
is($ret->snaks->[0]->datavalue->value, 'https://skim.cz', 'Get value.');
is($ret->snaks->[1]->property, 'P813', 'Get property.');
is($ret->snaks->[1]->datatype, 'time', 'Get datatype.');
isa_ok($ret->snaks->[1]->datavalue, 'Wikibase::Datatype::Value::Time');
is($ret->snaks->[1]->datavalue->value, '+2013-12-07T00:00:00Z', 'Get value.');

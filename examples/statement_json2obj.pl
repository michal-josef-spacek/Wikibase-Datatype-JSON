#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Statement qw(json2obj);

# Snak JSON structure.
my $json = <<'END';
{
  "id":"Q1234$1E0D43AE-0084-11EE-9F73-54E1ADF06DAE",
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

# Get object.
my $obj = json2obj($json);

# Print out.
print 'Id: '.$obj->id."\n";
print 'Claim: '.$obj->snak->property.' -> '.$obj->snak->datavalue->value."\n";
print "Qualifiers:\n";
foreach my $property_snak (@{$obj->property_snaks}) {
        print "\t".$property_snak->property.' -> '.
                $property_snak->datavalue->value."\n";
}
print "References:\n";
foreach my $reference (@{$obj->references}) {
        print "\tReference:\n";
        foreach my $reference_snak (@{$reference->snaks}) {
                print "\t\t".$reference_snak->property.' -> '.
                        $reference_snak->datavalue->value."\n";
        }
}
print 'Rank: '.$obj->rank."\n";

# Output:
# Id: Q1234$1E0D43AE-0084-11EE-9F73-54E1ADF06DAE
# Claim: P31 -> Q3331189
# Qualifiers:
#         P642 -> Q5185279
# References:
#         Reference:
#                 P248 -> Q53919
#                 P214 -> 113230702
#                 P813 -> +2013-12-07T00:00:00Z
# Rank: normal
#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Statement qw(obj2json);
use Wikibase::Datatype::Reference;
use Wikibase::Datatype::Snak;
use Wikibase::Datatype::Statement;
use Wikibase::Datatype::Value::Item;
use Wikibase::Datatype::Value::String;
use Wikibase::Datatype::Value::Time;

# Object.
my $obj = Wikibase::Datatype::Statement->new(
        'id' => 'Q123$00C04D2A-49AF-40C2-9930-C551916887E8',

        # instance of (P31) human (Q5)
        'snak' => Wikibase::Datatype::Snak->new(
                 'datatype' => 'wikibase-item',
                 'datavalue' => Wikibase::Datatype::Value::Item->new(
                         'value' => 'Q5',
                 ),
                 'property' => 'P31',
        ),
        'property_snaks' => [
                # of (P642) alien (Q474741)
                Wikibase::Datatype::Snak->new(
                         'datatype' => 'wikibase-item',
                         'datavalue' => Wikibase::Datatype::Value::Item->new(
                                 'value' => 'Q474741',
                         ),
                         'property' => 'P642',
                ),
        ],
        'references' => [
                 Wikibase::Datatype::Reference->new(
                         'snaks' => [
                                 # stated in (P248) Virtual International Authority File (Q53919)
                                 Wikibase::Datatype::Snak->new(
                                          'datatype' => 'wikibase-item',
                                          'datavalue' => Wikibase::Datatype::Value::Item->new(
                                                  'value' => 'Q53919',
                                          ),
                                          'property' => 'P248',
                                 ),

                                 # VIAF ID (P214) 113230702
                                 Wikibase::Datatype::Snak->new(
                                          'datatype' => 'external-id',
                                          'datavalue' => Wikibase::Datatype::Value::String->new(
                                                  'value' => '113230702',
                                          ),
                                          'property' => 'P214',
                                 ),

                                 # retrieved (P813) 7 December 2013
                                 Wikibase::Datatype::Snak->new(
                                          'datatype' => 'time',
                                          'datavalue' => Wikibase::Datatype::Value::Time->new(
                                                  'value' => '+2013-12-07T00:00:00Z',
                                          ),
                                          'property' => 'P813',
                                 ),
                         ],
                 ),
        ],
);

# Get JSON.
my $json = obj2json($obj, {
         'base_uri' => 'http://test.wikidata.org/entity/',
         'pretty' => 1,
});

# Print to output.
print $json;

# Output:
# {
#    "qualifiers-order" : [
#       "P642"
#    ],
#    "qualifiers" : {
#       "P642" : [
#          {
#             "datavalue" : {
#                "value" : {
#                   "numeric-id" : 474741,
#                   "id" : "Q474741",
#                   "entity-type" : "item"
#                },
#                "type" : "wikibase-entityid"
#             },
#             "snaktype" : "value",
#             "datatype" : "wikibase-item",
#             "property" : "P642"
#          }
#       ]
#    },
#    "id" : "Q123$00C04D2A-49AF-40C2-9930-C551916887E8",
#    "rank" : "normal",
#    "type" : "statement",
#    "references" : [
#       {
#          "snaks" : {
#             "P248" : [
#                {
#                   "datatype" : "wikibase-item",
#                   "property" : "P248",
#                   "snaktype" : "value",
#                   "datavalue" : {
#                      "type" : "wikibase-entityid",
#                      "value" : {
#                         "numeric-id" : 53919,
#                         "id" : "Q53919",
#                         "entity-type" : "item"
#                      }
#                   }
#                }
#             ],
#             "P214" : [
#                {
#                   "property" : "P214",
#                   "datatype" : "external-id",
#                   "snaktype" : "value",
#                   "datavalue" : {
#                      "type" : "string",
#                      "value" : "113230702"
#                   }
#                }
#             ],
#             "P813" : [
#                {
#                   "snaktype" : "value",
#                   "property" : "P813",
#                   "datatype" : "time",
#                   "datavalue" : {
#                      "type" : "time",
#                      "value" : {
#                         "time" : "+2013-12-07T00:00:00Z",
#                         "after" : 0,
#                         "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
#                         "before" : 0,
#                         "precision" : 11,
#                         "timezone" : 0
#                      }
#                   }
#                }
#             ]
#          },
#          "snaks-order" : [
#             "P248",
#             "P214",
#             "P813"
#          ]
#       }
#    ],
#    "mainsnak" : {
#       "property" : "P31",
#       "datatype" : "wikibase-item",
#       "snaktype" : "value",
#       "datavalue" : {
#          "value" : {
#             "numeric-id" : 5,
#             "entity-type" : "item",
#             "id" : "Q5"
#          },
#          "type" : "wikibase-entityid"
#       }
#    }
# }
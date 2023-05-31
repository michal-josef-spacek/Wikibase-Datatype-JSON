#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Reference qw(obj2json);
use Wikibase::Datatype::Reference;
use Wikibase::Datatype::Value::Item;

# Object.
# instance of (P31) human (Q5)
my $obj = Wikibase::Datatype::Reference->new(
         'snaks' => [
                 Wikibase::Datatype::Snak->new(
                         'datatype' => 'url',
                         'datavalue' => Wikibase::Datatype::Value::String->new(
                                 'value' => 'https://skim.cz',
                         ),
                         'property' => 'P854',
                 ),
                 Wikibase::Datatype::Snak->new(
                         'datatype' => 'time',
                         'datavalue' => Wikibase::Datatype::Value::Time->new(
                                 'value' => '+2013-12-07T00:00:00Z',
                         ),
                         'property' => 'P813',
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
#    "snaks" : {
#       "P854" : [
#          {
#             "property" : "P854",
#             "snaktype" : "value",
#             "datavalue" : {
#                "value" : "https://skim.cz",
#                "type" : "string"
#             },
#             "datatype" : "url"
#          }
#       ],
#       "P813" : [
#          {
#             "datavalue" : {
#                "type" : "time",
#                "value" : {
#                   "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
#                   "time" : "+2013-12-07T00:00:00Z",
#                   "precision" : 11,
#                   "timezone" : 0,
#                   "after" : 0,
#                   "before" : 0
#                }
#             },
#             "datatype" : "time",
#             "property" : "P813",
#             "snaktype" : "value"
#          }
#       ]
#    },
#    "snaks-order" : [
#       "P854",
#       "P813"
#    ]
# }
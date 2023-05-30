#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Snak qw(obj2json);
use Wikibase::Datatype::Snak;
use Wikibase::Datatype::Value::Item;

# Object.
# instance of (P31) human (Q5)
my $obj = Wikibase::Datatype::Snak->new(
         'datatype' => 'wikibase-item',
         'datavalue' => Wikibase::Datatype::Value::Item->new(
                 'value' => 'Q5',
         ),
         'property' => 'P31',
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
#    "datavalue" : {
#       "type" : "wikibase-entityid",
#       "value" : {
#          "id" : "Q5",
#          "numeric-id" : 5,
#          "entity-type" : "item"
#       }
#    },
#    "property" : "P31",
#    "snaktype" : "value",
#    "datatype" : "wikibase-item"
# }
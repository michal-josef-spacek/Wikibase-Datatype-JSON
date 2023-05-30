#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::Value::Item;
use Wikibase::Datatype::JSON::Value::Item qw(obj2json);

# Object.
my $obj = Wikibase::Datatype::Value::Item->new(
        'value' => 'Q123',
);

# Get JSON string.
my $json = obj2json($obj, {'pretty' => 1});

# Print out.
print $json;

# Output:
# {
#    "type" : "wikibase-entityid",
#    "value" : {
#       "entity-type" : "item",
#       "numeric-id" : 123,
#       "id" : "Q123"
#    }
# }
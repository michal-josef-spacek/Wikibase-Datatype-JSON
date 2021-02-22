#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Property qw(obj2json);
use Wikibase::Datatype::Value::Property;

# Object.
my $obj = Wikibase::Datatype::Value::Property->new(
        'value' => 'P123',
);

# Get JSON.
my $json = obj2json($obj, {'pretty' => 1});

# Print to output.
print $json;

# Output:
# {
#    "type" : "wikibase-entityid",
#    "value" : {
#       "numeric-id" : 123,
#       "entity-type" : "property",
#       "id" : "P123"
#    }
# }
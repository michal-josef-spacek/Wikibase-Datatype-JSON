#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::Value::Quantity;
use Wikibase::Datatype::JSON::Value::Quantity qw(obj2json);

# Object.
my $obj = Wikibase::Datatype::Value::Quantity->new(
        'unit' => 'Q190900',
        'value' => 10,
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
#    "value" : {
#       "amount" : "+10",
#       "unit" : "http://test.wikidata.org/entity/Q190900"
#    },
#    "type" : "quantity"
# }
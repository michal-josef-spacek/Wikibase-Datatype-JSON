#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikibase::Datatype::Value::Globecoordinate;
use Wikibase::Datatype::JSON::Value::Globecoordinate qw(obj2json);

# Object.
my $obj = Wikibase::Datatype::Value::Globecoordinate->new(
        'value' => [49.6398383, 18.1484031],
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
#       "globe" : "http://test.wikidata.org/entity/Q2",
#       "altitude" : null,
#       "longitude" : 18.1484031,
#       "latitude" : 49.6398383,
#       "precision" : 1e-07
#    },
#    "type" : "globecoordinate"
# }
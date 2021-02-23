#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikibase::Datatype::Value::Time;
use Wikibase::Datatype::JSON::Value::Time qw(obj2json);

# Object.
my $obj = Wikibase::Datatype::Value::Time->new(
        'precision' => 10,
        'value' => '+2020-09-01T00:00:00Z',
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
#    "type" : "time",
#    "value" : {
#       "timezone" : 0,
#       "before" : 0,
#       "precision" : 10,
#       "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
#       "time" : "+2020-09-01T00:00:00Z",
#       "after" : 0
#    }
# }
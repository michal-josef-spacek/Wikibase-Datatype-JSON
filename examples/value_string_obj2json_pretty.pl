#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::Value::String;
use Wikibase::Datatype::JSON::Value::String qw(obj2json);

# Object.
my $obj = Wikibase::Datatype::Value::String->new(
        'value' => 'foo',
);

# Get JSON string.
my $json = obj2json($obj, {'pretty' => 1});

# Print out.
print $json;

# Output:
# {
#    "value" : "foo",
#    "type" : "string"
# }
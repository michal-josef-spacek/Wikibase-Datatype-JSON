#!/usr/bin/env perl

use strict;
use warnings;

use Data::Printer;
use Wikibase::Datatype::JSON::Value::Property qw(obj2json);
use Wikibase::Datatype::Value::Property;

# Object.
my $obj = Wikibase::Datatype::Value::Property->new(
        'value' => 'P123',
);

# Get structure.
my $struct_hr = obj2json($obj);

# Dump to output.
p $struct_hr;

# Output:
# \ {
#     type    "wikibase-entityid",
#     value   {
#         entity-type   "property",
#         id            "P123",
#         numeric-id    123
#     }
# }
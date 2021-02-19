#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::Value::Monolingual;
use Wikibase::Datatype::JSON::Value::Monolingual qw(obj2json);

# Object.
my $obj = Wikibase::Datatype::Value::Monolingual->new(
        'language' => 'en',
        'value' => 'English text',
);

# Get JSON.
my $json = obj2json($obj, { pretty => 1 });

# Print to output.
print $json;

# Output:
# {
#    "value" : {
#       "language" : "en",
#       "text" : "English text"
#    },
#    "type" : "monolingualtext"
# }
#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Item qw(json2obj);

# JSON string.
my $json = <<'END';
{
   "type" : "wikibase-entityid",
   "value" : {
      "entity-type" : "item",
      "numeric-id" : 123,
      "id" : "Q123"
   }
}
END

# Get object.
my $obj = json2obj($json);

# Get value.
my $value = $obj->value;

# Get type.
my $type = $obj->type;

# Print out.
print "Type: $type\n";
print "Value: $value\n";

# Output:
# Type: item
# Value: Q123
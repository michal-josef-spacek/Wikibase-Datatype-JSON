#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Property qw(json2obj);

# Property JSON.
my $json = <<'END';
{
   "type" : "wikibase-entityid",
   "value" : {
      "numeric-id" : 123,
      "entity-type" : "property",
      "id" : "P123"
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
# Type: property
# Value: P123
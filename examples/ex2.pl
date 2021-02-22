#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::String qw(json2obj);

# JSON structure.
my $json = <<'END';
{
   "value" : "foo",
   "type" : "string"
}
END

# Get object.
my $obj = json2obj($json);

# Get type.
my $type = $obj->type;

# Get value.
my $value = $obj->value;

# Print out.
print "Type: $type\n";
print "Value: $value\n";

# Output:
# Type: string
# Value: foo
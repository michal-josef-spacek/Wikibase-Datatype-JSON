#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Snak qw(json2obj);

# Snak JSON structure.
my $json = <<'END';
{
   "datavalue" : {
      "type" : "wikibase-entityid",
      "value" : {
         "id" : "Q5",
         "numeric-id" : 5,
         "entity-type" : "item"
      }
   },
   "property" : "P31",
   "snaktype" : "value",
   "datatype" : "wikibase-item"
}
END

# Get object.
my $obj = json2obj($json);

# Get value.
my $datavalue = $obj->datavalue->value;

# Get datatype.
my $datatype = $obj->datatype;

# Get property.
my $property = $obj->property;

# Print out.
print "Property: $property\n";
print "Type: $datatype\n";
print "Value: $datavalue\n";

# Output:
# Property: P31
# Type: wikibase-item
# Value: Q5

#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Quantity qw(json2obj);

# Quantity structure.
my $json = <<'END';
{
   "value" : {
      "amount" : "+10",
      "unit" : "http://test.wikidata.org/entity/Q190900"
   },
   "type" : "quantity"
}
END

# Get object.
my $obj = json2obj($json);

# Get type.
my $type = $obj->type;

# Get unit.
my $unit = $obj->unit;

# Get value.
my $value = $obj->value;

# Print out.
print "Type: $type\n";
if (defined $unit) {
        print "Unit: $unit\n";
}
print "Value: $value\n";

# Output:
# Type: quantity
# Unit: Q190900
# Value: 10
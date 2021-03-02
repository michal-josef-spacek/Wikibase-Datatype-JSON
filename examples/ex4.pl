#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Time qw(json2obj);

# Time structure.
my $json = <<'END';
{
   "type" : "time",
   "value" : {
      "timezone" : 0,
      "before" : 0,
      "precision" : 10,
      "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
      "time" : "+2020-09-01T00:00:00Z",
      "after" : 0
   }
}
END

# Get object.
my $obj = json2obj($json);

# Get calendar model.
my $calendarmodel = $obj->calendarmodel;

# Get precision.
my $precision = $obj->precision;

# Get type.
my $type = $obj->type;

# Get value.
my $value = $obj->value;

# Print out.
print "Calendar model: $calendarmodel\n";
print "Precision: $precision\n";
print "Type: $type\n";
print "Value: $value\n";

# Output:
# Calendar model: Q1985727
# Precision: 10
# Type: time
# Value: +2020-09-01T00:00:00Z
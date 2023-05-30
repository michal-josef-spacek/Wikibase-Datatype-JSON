#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Globecoordinate qw(json2obj);

# Globe coordinate structure.
my $json = <<'END';
{
   "value" : {
      "globe" : "http://test.wikidata.org/entity/Q2",
      "altitude" : null,
      "longitude" : 18.1484031,
      "latitude" : 49.6398383,
      "precision" : 1e-07
   },
   "type" : "globecoordinate"
}
END

# Get object.
my $obj = json2obj($json);

# Get globe.
my $globe = $obj->globe;

# Get longitude.
my $longitude = $obj->longitude;

# Get latitude.
my $latitude = $obj->latitude;

# Get precision.
my $precision = $obj->precision;

# Get type.
my $type = $obj->type;

# Get value.
my $value_ar = $obj->value;

# Print out.
print "Globe: $globe\n";
print "Latitude: $latitude\n";
print "Longitude: $longitude\n";
print "Precision: $precision\n";
print "Type: $type\n";
print 'Value: '.(join ', ', @{$value_ar})."\n";

# Output:
# Globe: Q2
# Latitude: 49.6398383
# Longitude: 18.1484031
# Precision: 1e-07
# Type: globecoordinate
# Value: 49.6398383, 18.1484031
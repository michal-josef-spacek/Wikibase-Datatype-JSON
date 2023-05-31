#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Reference qw(json2obj);

# Reference JSON structure.
my $json = <<'END';
{
   "snaks" : {
      "P854" : [
         {
            "property" : "P854",
            "snaktype" : "value",
            "datavalue" : {
               "value" : "https://skim.cz",
               "type" : "string"
            },
            "datatype" : "url"
         }
      ],
      "P813" : [
         {
            "datavalue" : {
               "type" : "time",
               "value" : {
                  "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
                  "time" : "+2013-12-07T00:00:00Z",
                  "precision" : 11,
                  "timezone" : 0,
                  "after" : 0,
                  "before" : 0
               }
            },
            "datatype" : "time",
            "property" : "P813",
            "snaktype" : "value"
         }
      ]
   },
   "snaks-order" : [
      "P854",
      "P813"
   ]
}
END

# Get object.
my $obj = json2obj($json);

# Get value.
my $snaks_ar = $obj->snaks;

# Print out.
print "Number of snaks: ".@{$snaks_ar}."\n";

# Output:
# Number of snaks: 2
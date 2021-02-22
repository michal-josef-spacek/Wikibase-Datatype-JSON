#!/usr/bin/env perl

use strict;
use warnings;

use Wikibase::Datatype::JSON::Value::Monolingual qw(json2obj);

# Monolingualtext JSON structure.
my $json = <<'END';
{
   "value" : {
      "language" : "en",
      "text" : "English text"
   },
   "type" : "monolingualtext"
}
END

# Get object.
my $obj = json2obj($json);

# Get language.
my $language = $obj->language;

# Get type.
my $type = $obj->type;

# Get value.
my $value = $obj->value;

# Print out.
print "Language: $language\n";
print "Type: $type\n";
print "Value: $value\n";

# Output:
# Language: en
# Type: monolingualtext
# Value: English text
use strict;
use warnings;

use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::String;

# Test.
my $json = <<'END';
{
  "value": "Text",
  "type": "string"
}
END
my $ret = Wikibase::Datatype::JSON::Value::String::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::String');
is($ret->value, 'Text', 'Method value().');
is($ret->type, 'string', 'Method type().');

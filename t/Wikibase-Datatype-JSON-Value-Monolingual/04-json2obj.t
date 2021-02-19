use strict;
use warnings;

use Test::More 'tests' => 5;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);
use Wikibase::Datatype::JSON::Value::Monolingual;

# Test.
my $json = decode_utf8(<<'END');
{
  "value": {
    "language": "cs",
    "text": "Příklad"
  },
  "type": "monolingualtext"
}
END
my $ret = Wikibase::Datatype::JSON::Value::Monolingual::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Monolingual');
is($ret->value, decode_utf8('Příklad'), 'Method value().');
is($ret->language, 'cs', 'Method language().');
is($ret->type, 'monolingualtext', 'Method type().');

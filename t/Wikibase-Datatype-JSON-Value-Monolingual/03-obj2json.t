use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::JSON::Type;
use Test::More 'tests' => 5;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8 encode_utf8);
use Wikibase::Datatype::Value::Monolingual;
use Wikibase::Datatype::JSON::Value::Monolingual;

# Test.
my $obj = Wikibase::Datatype::Value::Monolingual->new(
	'language' => 'cs',
	'value' => decode_utf8('Příklad'),
);
my $json = Wikibase::Datatype::JSON::Value::Monolingual::obj2json($obj);
my $right_json = decode_utf8(<<'END');
{
  "value": {
    "language": "cs",
    "text": "Příklad"
  },
  "type": "monolingualtext"
}
END
cmp_json_types(encode_utf8($json), encode_utf8($right_json),
	'Output of obj2json() subroutine.');

# Test.
$obj = Wikibase::Datatype::Value::Monolingual->new(
	'language' => 'cs',
	'value' => decode_utf8('Příklad'),
);
$json = Wikibase::Datatype::JSON::Value::Monolingual::obj2json($obj, {'pretty' => 1});
$right_json = decode_utf8(<<'END');
{
  "value": {
    "language": "cs",
    "text": "Příklad"
  },
  "type": "monolingualtext"
}
END
cmp_json_types(encode_utf8($json), encode_utf8($right_json),
	'Output of obj2json() subroutine (pretty print).');

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Monolingual::obj2json('bad');
};
is($EVAL_ERROR, "Object isn't 'Wikibase::Datatype::Value::Monolingual'.\n",
	"Object isn't 'Wikibase::Datatype::Value::Monolingual'.");
clean();

# Test.
eval {
	Wikibase::Datatype::JSON::Value::Monolingual::obj2json();
};
is($EVAL_ERROR, "Object doesn't exist.\n", "Object doesn't exist.");
clean();

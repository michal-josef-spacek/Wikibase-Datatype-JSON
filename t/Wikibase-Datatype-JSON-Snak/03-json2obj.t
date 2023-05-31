use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 17;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Snak;

# Test.
my $json = <<'END';
{
  "datavalue":{
    "type":"string",
    "value":"1.1"
  },
  "snaktype":"value",
  "property":"P11",
  "datatype":"string"
}
END
my $ret = Wikibase::Datatype::JSON::Snak::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Snak');
is($ret->datatype, 'string', 'Method datatype().');
isa_ok($ret->datavalue, 'Wikibase::Datatype::Value::String');
is($ret->property, 'P11', 'Method property().');
is($ret->snaktype, 'value', 'Method snaktype().');

# Test.
$json = <<'END';
{
  "snaktype":"novalue",
  "property":"P11",
  "datatype":"string"
}
END
$ret = Wikibase::Datatype::JSON::Snak::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Snak');
is($ret->datatype, 'string', 'Method datatype().');
is($ret->datavalue, undef, 'No value.');
is($ret->property, 'P11', 'Method property().');
is($ret->snaktype, 'novalue', 'Method snaktype().');

# Test.
$json = <<'END';
{
  "snaktype":"somevalue",
  "property":"P11",
  "datatype":"string"
}
END
$ret = Wikibase::Datatype::JSON::Snak::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Snak');
is($ret->datatype, 'string', 'Method datatype().');
is($ret->datavalue, undef, 'Some value.');
is($ret->property, 'P11', 'Method property().');
is($ret->snaktype, 'somevalue', 'Method snaktype().');

# Test.
$json = <<'END';
{
  "datatype":"wikibase-item"
}
END
eval {
	Wikibase::Datatype::JSON::Snak::json2obj($json);
};
is($EVAL_ERROR, "Parameter 'datavalue' is required.\n",
	"Parameter 'datavalue' is required.");
clean();

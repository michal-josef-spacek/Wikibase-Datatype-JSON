use strict;
use warnings;

use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 11;
use Test::NoWarnings;
use Wikibase::Datatype::JSON::Value::Item;

# Test.
my $json = <<'END';
{
   "value" : {
      "numeric-id" : 497,
      "entity-type" : "item",
      "id" : "Q497"
   },
   "type" : "wikibase-entityid"
}
END
my $ret = Wikibase::Datatype::JSON::Value::Item::json2obj($json);
isa_ok($ret, 'Wikibase::Datatype::Value::Item');
is($ret->value, 'Q497', 'Method value().');
is($ret->type, 'item', 'Method type().');

# Test.
$json = <<'END';
{}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (blank structure).");
clean();

# Test.
$json = <<'END';
{
  "type" : null
}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (type is null).");
clean();

# Test.
$json = <<'END';
{
  "type" : "bad"
}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (bad type).");
clean();

# Test.
$json = <<'END';
{
  "type" : "wikibase-entityid"
}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (only filled type).");
clean();

# Test.
$json = <<'END';
{
  "type" : "wikibase-entityid",
  "value" : {
  }
}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (value is blank).");
clean();

# Test.
$json = <<'END';
{
  "type" : "wikibase-entityid",
  "value" : {
    "entity-type" : null
  }
}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (value has only entity-type with null).");
clean();

# Test.
$json = <<'END';
{
  "type" : "wikibase-entityid",
  "value" : {
    "entity-type" : "bad"
  }
}
END
eval {
	Wikibase::Datatype::JSON::Value::Item::json2obj($json);
};
is($EVAL_ERROR, "Structure isn't for 'item' datatype.\n",
	"Structure isn't for 'item' datatype (value has only entity-type with bad value).");
clean();

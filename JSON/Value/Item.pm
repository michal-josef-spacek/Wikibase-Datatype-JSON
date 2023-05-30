package Wikibase::Datatype::JSON::Value::Item;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::Struct::Value::Item;
use Wikibase::Datatype::Value::Item;

Readonly::Array our @EXPORT_OK => qw(obj2json json2obj json_type);

our $VERSION = 0.01;

sub obj2json {
	my ($obj, $opts_hr) = @_;

	if (! defined $opts_hr) {
		$opts_hr = {};
	}
	if (! exists $opts_hr->{'pretty'}) {
		$opts_hr->{'pretty'} = 0;
	}

	if (! defined $obj) {
		err "Object doesn't exist.";
	}
	if (! $obj->isa('Wikibase::Datatype::Value::Item')) {
		err "Object isn't 'Wikibase::Datatype::Value::Item'.";
	}

	my $numeric_id = $obj->value;
	$numeric_id =~ s/^Q//ms;

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $json = $json_o->encode({
		'value' => {
			'entity-type' => $obj->type,
			'id' => $obj->value,
			'numeric-id' => $numeric_id,
		},
		'type' => 'wikibase-entityid',
	}, json_type());

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	return Wikibase::Datatype::Struct::Value::Item::struct2obj($struct_hr);
}

sub json_type {
	return {
		'value' => {
			'entity-type' => JSON_TYPE_STRING,
			'id' => JSON_TYPE_STRING,
			'numeric-id' => JSON_TYPE_INT,
		},
		'type' => JSON_TYPE_STRING,
	};
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::Item - Wikibase item JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::Struct::Value::Item qw(obj2json json2obj);

 my $json = obj2json($obj, $opts_hr);
 my $obj = json2obj($json);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Value::Item instance to JSON structure.
C<$opts_hr> are optional settings. There is 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert structure of item JSON string to object.

Returns Wikibase::Datatype::Value::Item instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::Item'.

 json2obj():
         From Wikibase::Datatype::Struct::Value::Item::struct2obj():
                 Structure isn't for 'item' datatype.

=head1 EXAMPLE1

=for comment filename=value_item_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::Value::Item;
 use Wikibase::Datatype::JSON::Value::Item qw(obj2json);

 # Object.
 my $obj = Wikibase::Datatype::Value::Item->new(
         'value' => 'Q123',
 );

 # Get JSON string.
 my $json = obj2json($obj, {'pretty' => 1});

 # Print out.
 print $json;

 # Output:
 # {
 #    "type" : "wikibase-entityid",
 #    "value" : {
 #       "entity-type" : "item",
 #       "numeric-id" : 123,
 #       "id" : "Q123"
 #    }
 # }

=head1 EXAMPLE2

=for comment filename=value_item_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::Item qw(json2obj);

 # JSON string.
 my $json = <<'END';
 {
    "type" : "wikibase-entityid",
    "value" : {
       "entity-type" : "item",
       "numeric-id" : 123,
       "id" : "Q123"
    }
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get value.
 my $value = $obj->value;

 # Get type.
 my $type = $obj->type;

 # Print out.
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Type: item
 # Value: Q123

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::Struct::Value::Item>,
L<Wikibase::Datatype::Value::Item>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase structure serialization.

=item L<Wikibase::Datatype::Value::Item>

Wikibase item value datatype.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikibase-Datatype-JSON>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2021

BSD 2-Clause License

=head1 VERSION

0.01

=cut

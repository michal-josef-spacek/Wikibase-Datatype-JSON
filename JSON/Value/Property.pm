package Wikibase::Datatype::JSON::Value::Property;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::Struct::Value::Property;
use Wikibase::Datatype::Value::Property;

Readonly::Array our @EXPORT_OK => qw(json2obj json_type obj2json);

our $VERSION = 0.01;

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	return Wikibase::Datatype::Struct::Value::Property::struct2obj($struct_hr);
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
	if (! $obj->isa('Wikibase::Datatype::Value::Property')) {
		err "Object isn't 'Wikibase::Datatype::Value::Property'.";
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $numeric_id = $obj->value;
	$numeric_id =~ s/^P//ms;
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

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::Property - Wikibase property JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value::Property qw(json2obj json_type obj2json);

 my $obj = json2obj($struct_hr);
 my $json_type_hr = json_type($obj);
 my $struct_hr = obj2json($obj);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<json2obj>

 my $obj = json2obj($struct_hr);

Convert structure of property to object.

Returns Wikibase::Datatype::Value::Property instance.

=head2 C<json_type>

 my $json_type_hr = json_type($obj);

Get JSON type defined in L<Cpanel::JSON::XS::Type>.

Returns reference to hash.

=head2 C<obj2json>

 my $struct_hr = obj2json($obj);

Convert Wikibase::Datatype::Value::Property instance to structure.

Returns reference to hash with structure.

=head1 ERRORS

 json2obj():
         From Wikibase::Datatype::Struct::Value::Property::struct2obj():
                 Structure isn't for 'property' datatype.

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::Property'.

=head1 EXAMPLE1

=for comment filename=value_property_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::Property qw(json2obj);

 # Property JSON.
 my $json = <<'END';
 {
    "type" : "wikibase-entityid",
    "value" : {
       "numeric-id" : 123,
       "entity-type" : "property",
       "id" : "P123"
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
 # Type: property
 # Value: P123

=head1 EXAMPLE2

=for comment filename=value_property_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::Property qw(obj2json);
 use Wikibase::Datatype::Value::Property;

 # Object.
 my $obj = Wikibase::Datatype::Value::Property->new(
         'value' => 'P123',
 );

 # Get JSON.
 my $json = obj2json($obj, {'pretty' => 1});

 # Print to output.
 print $json;

 # Output:
 # {
 #    "type" : "wikibase-entityid",
 #    "value" : {
 #       "numeric-id" : 123,
 #       "entity-type" : "property",
 #       "id" : "P123"
 #    }
 # }

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::Struct::Value::Property>,
L<Wikibase::Datatype::Value::Property>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase JSON structure serialization.

=item L<Wikibase::Datatype::Value::Property>

Wikibase property value datatype.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikibase-Datatype-JSON>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2021-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut

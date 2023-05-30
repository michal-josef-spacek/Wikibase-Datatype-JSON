package Wikibase::Datatype::JSON::Snak;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::JSON::Value;
use Wikibase::Datatype::Snak;
use Wikibase::Datatype::Struct::Value;

Readonly::Array our @EXPORT_OK => qw(json2obj json_type obj2json);

our $VERSION = 0.01;

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	# Data value isn't required for snaktype 'novalue'.
	my $datavalue;
	if (exists $struct_hr->{'datavalue'}) {
		$datavalue = Wikibase::Datatype::Struct::Value::struct2obj($struct_hr->{'datavalue'});
	}

	my $obj = Wikibase::Datatype::Snak->new(
		'datavalue' => $datavalue,
		'datatype' => $struct_hr->{'datatype'},
		'property' => $struct_hr->{'property'},
		'snaktype' => $struct_hr->{'snaktype'},
	);

	return $obj;
}

sub json_type {
	my $obj = shift;

	return {
		defined $obj->datavalue
			? ('datavalue' => Wikibase::Datatype::JSON::Value::json_type($obj->datavalue))
			: (),
		'datatype' => JSON_TYPE_STRING,
		'property' => JSON_TYPE_STRING,
		'snaktype' => JSON_TYPE_STRING_OR_NULL,
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
	if (! $obj->isa('Wikibase::Datatype::Snak')) {
		err "Object isn't 'Wikibase::Datatype::Snak'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $json = $json_o->encode({
		defined $obj->datavalue
			? ('datavalue' => Wikibase::Datatype::Struct::Value::obj2struct($obj->datavalue, $opts_hr))
			: (),
		'datatype' => $obj->datatype,
		'property' => $obj->property,
		'snaktype' => $obj->snaktype,
	}, json_type($obj));

	return $json;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Snak - Wikibase snak JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Snak qw(json2obj json_type obj2json);

 my $obj = json2obj($json);
 my $json_type_hr = json_type($obj);
 my $json = obj2json($obj, $opts_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of snak to object.

Returns Wikibase::Datatype::Snak instance.

=head2 C<json_type>

 my $json_type_hr = json_type($obj);

Get JSON type defined in L<Cpanel::JSON::XS::Type>.

Returns reference to hash.

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Snak instance to JSON structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Snak'.
         Parameter 'base_uri' is required.

=head1 EXAMPLE1

=for comment filename=snak_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Snak qw(json2obj);

 # Snak JSON structure.
 my $json = <<'END';
 {
    "datavalue" : {
       "type" : "wikibase-entityid",
       "value" : {
          "id" : "Q5",
          "numeric-id" : 5,
          "entity-type" : "item"
       }
    },
    "property" : "P31",
    "snaktype" : "value",
    "datatype" : "wikibase-item"
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get value.
 my $datavalue = $obj->datavalue->value;

 # Get datatype.
 my $datatype = $obj->datatype;

 # Get property.
 my $property = $obj->property;

 # Print out.
 print "Property: $property\n";
 print "Type: $datatype\n";
 print "Value: $datavalue\n";

 # Output:
 # Property: P31
 # Type: wikibase-item
 # Value: Q5

=head1 EXAMPLE2

=for comment filename=snak_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Snak qw(obj2json);
 use Wikibase::Datatype::Snak;
 use Wikibase::Datatype::Value::Item;

 # Object.
 # instance of (P31) human (Q5)
 my $obj = Wikibase::Datatype::Snak->new(
          'datatype' => 'wikibase-item',
          'datavalue' => Wikibase::Datatype::Value::Item->new(
                  'value' => 'Q5',
          ),
          'property' => 'P31',
 );

 # Get JSON.
 my $json = obj2json($obj, {
          'base_uri' => 'http://test.wikidata.org/entity/',
          'pretty' => 1,
 });

 # Print to output.
 print $json;

 # Output:
 # {
 #    "datavalue" : {
 #       "type" : "wikibase-entityid",
 #       "value" : {
 #          "id" : "Q5",
 #          "numeric-id" : 5,
 #          "entity-type" : "item"
 #       }
 #    },
 #    "property" : "P31",
 #    "snaktype" : "value",
 #    "datatype" : "wikibase-item"
 # }

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::Snak>,
L<Wikibase::Datatype::Struct::Value>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase structure JSON serialization.

=item L<Wikibase::Datatype::Snak>

Wikibase snak datatype.

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

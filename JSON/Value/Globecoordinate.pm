package Wikibase::Datatype::JSON::Value::Globecoordinate;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use URI;
use Wikibase::Datatype::Struct::Value::Globecoordinate;
use Wikibase::Datatype::Value::Globecoordinate;

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
	if (! $obj->isa('Wikibase::Datatype::Value::Globecoordinate')) {
		err "Object isn't 'Wikibase::Datatype::Value::Globecoordinate'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}
	my $json = $json_o->encode({
		'value' => {
			'altitude' => $obj->altitude,
			'globe' => $opts_hr->{'base_uri'}.$obj->globe,
			'latitude' => $obj->latitude,
			'longitude' => $obj->longitude,
			'precision' => $obj->precision,
		},
		'type' => $obj->type,
	}, json_type());

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	return Wikibase::Datatype::Struct::Value::Globecoordinate::struct2obj($struct_hr);
}

sub json_type {
	return {
		'value' => {
			'altitude' => JSON_TYPE_FLOAT_OR_NULL,
			'globe' => JSON_TYPE_STRING,
			'latitude' => JSON_TYPE_FLOAT,
			'longitude' => JSON_TYPE_FLOAT,
			'precision' => JSON_TYPE_FLOAT,
		},
		'type' => JSON_TYPE_STRING,
	},
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::Globecoordinate - Wikibase globe coordinate JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value::Globecoordinate qw(obj2json json2obj);

 my $json = obj2json($obj, $opts_hr);
 my $obj = json2obj($json);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Value::Globecoordinate instance to JSON structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of globe coordinate to object.

Returns Wikibase::Datatype::Value::Globecoordinate instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::Globecoordinate'.
         Parameter 'base_uri' is required.

 json2obj():
         From Wikibase::Datatype::Struct::Value::Globecoordinate::struct2obj():
                 Structure isn't for 'globecoordinate' datatype.

=head1 EXAMPLE1

=for comment filename=value_globecoordinate_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::Value::Globecoordinate;
 use Wikibase::Datatype::JSON::Value::Globecoordinate qw(obj2json);

 # Object.
 my $obj = Wikibase::Datatype::Value::Globecoordinate->new(
         'value' => [49.6398383, 18.1484031],
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
 #    "value" : {
 #       "globe" : "http://test.wikidata.org/entity/Q2",
 #       "altitude" : null,
 #       "longitude" : 18.1484031,
 #       "latitude" : 49.6398383,
 #       "precision" : 1e-07
 #    },
 #    "type" : "globecoordinate"
 # }

=head1 EXAMPLE2

=for comment filename=value_globecoordinate_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::Globecoordinate qw(json2obj);

 # Globe coordinate structure.
 my $json = <<'END';
 {
    "value" : {
       "globe" : "http://test.wikidata.org/entity/Q2",
       "altitude" : null,
       "longitude" : 18.1484031,
       "latitude" : 49.6398383,
       "precision" : 1e-07
    },
    "type" : "globecoordinate"
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get globe.
 my $globe = $obj->globe;

 # Get longitude.
 my $longitude = $obj->longitude;

 # Get latitude.
 my $latitude = $obj->latitude;

 # Get precision.
 my $precision = $obj->precision;

 # Get type.
 my $type = $obj->type;

 # Get value.
 my $value_ar = $obj->value;

 # Print out.
 print "Globe: $globe\n";
 print "Latitude: $latitude\n";
 print "Longitude: $longitude\n";
 print "Precision: $precision\n";
 print "Type: $type\n";
 print 'Value: '.(join ', ', @{$value_ar})."\n";

 # Output:
 # Globe: Q2
 # Latitude: 49.6398383
 # Longitude: 18.1484031
 # Precision: 1e-07
 # Type: globecoordinate
 # Value: 49.6398383, 18.1484031

=head1 DEPENDENCIES

L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<URI>,
L<Wikibase::Datatype::Struct::Value::Globecoordinate>,
L<Wikibase::Datatype::Value::Globecoordinate>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase JSON structure serialization.

=item L<Wikibase::Datatype::Value::Globecoordinate>

Wikibase globe coordinate value datatype.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikibase-Datatype-JSON>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2021 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut

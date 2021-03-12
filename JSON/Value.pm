package Wikibase::Datatype::JSON::Value;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::JSON::Value::Globecoordinate;
use Wikibase::Datatype::JSON::Value::Item;
use Wikibase::Datatype::JSON::Value::Monolingual;
use Wikibase::Datatype::JSON::Value::Property;
use Wikibase::Datatype::JSON::Value::Quantity;
use Wikibase::Datatype::JSON::Value::String;
use Wikibase::Datatype::JSON::Value::Time;
use Wikibase::Datatype::Struct::Value::Globecoordinate;
use Wikibase::Datatype::Struct::Value::Item;
use Wikibase::Datatype::Struct::Value::Monolingual;
use Wikibase::Datatype::Struct::Value::Property;
use Wikibase::Datatype::Struct::Value::Quantity;
use Wikibase::Datatype::Struct::Value::String;
use Wikibase::Datatype::Struct::Value::Time;
use Wikibase::Datatype::Value;

Readonly::Array our @EXPORT_OK => qw(obj2json json2obj);

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
	if (! $obj->isa('Wikibase::Datatype::Value')) {
		err "Object isn't 'Wikibase::Datatype::Value'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $json;
	my $type = $obj->type;
	if ($type eq 'globecoordinate') {
		$json = Wikibase::Datatype::JSON::Value::Globecoordinate::obj2json($obj, $opts_hr);
	} elsif ($type eq 'item') {
		$json = Wikibase::Datatype::JSON::Value::Item::obj2json($obj, $opts_hr);
	} elsif ($type eq 'monolingualtext') {
		$json = Wikibase::Datatype::JSON::Value::Monolingual::obj2json($obj, $opts_hr);
	} elsif ($type eq 'property') {
		$json = Wikibase::Datatype::JSON::Value::Property::obj2json($obj, $opts_hr);
	} elsif ($type eq 'quantity') {
		$json = Wikibase::Datatype::JSON::Value::Quantity::obj2json($obj, $opts_hr);
	} elsif ($type eq 'string') {
		$json = Wikibase::Datatype::JSON::Value::String::obj2json($obj, $opts_hr);
	} elsif ($type eq 'time') {
		$json = Wikibase::Datatype::JSON::Value::Time::obj2json($obj, $opts_hr);
	} else {
		err "Type '$type' is unsupported.";
	}

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	if (! exists $struct_hr->{'type'}) {
		err "Type doesn't exist.";
	}

	my $obj;
	if ($struct_hr->{'type'} eq 'globecoordinate') {
		$obj = Wikibase::Datatype::Struct::Value::Globecoordinate::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'monolingualtext') {
		$obj = Wikibase::Datatype::Struct::Value::Monolingual::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'quantity') {
		$obj = Wikibase::Datatype::Struct::Value::Quantity::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'string') {
		$obj = Wikibase::Datatype::Struct::Value::String::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'time') {
		$obj = Wikibase::Datatype::Struct::Value::Time::struct2obj($struct_hr);
	} elsif ($struct_hr->{'type'} eq 'wikibase-entityid') {
		if ($struct_hr->{'value'}->{'entity-type'} eq 'item') {
			$obj = Wikibase::Datatype::Struct::Value::Item::struct2obj($struct_hr);
		} elsif ($struct_hr->{'value'}->{'entity-type'} eq 'property') {
			$obj = Wikibase::Datatype::Struct::Value::Property::struct2obj($struct_hr);
		} else {
			err "Entity type '$struct_hr->{'value'}->{'entity-type'}' is unsupported.";
		}
	} else {
		err "Type '$struct_hr->{'type'}' is unsupported.";
	}

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value - Wikibase value JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value qw(obj2json json2obj);

 my $json = obj2json($obj, $opts_hr);
 my $obj = json2obj($json);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Value instance to JSON structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of value to object.

Returns Wikibase::Datatype::Value instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value'.
         Type '%s' is unsupported.
         Parameter 'base_uri' is required.

 json2obj():
         Entity type '%s' is unsupported.
         Type doesn't exist.
         Type '%s' is unsupported.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikibase::Datatype::Value::Time;
 use Wikibase::Datatype::JSON::Value qw(obj2json);

 # Object.
 my $obj = Wikibase::Datatype::Value::Time->new(
         'precision' => 10,
         'value' => '+2020-09-01T00:00:00Z',
 );

 # Get JSON.
 my $json = obj2json($obj, {
         'base_uri' => 'http://test.wikidata.org/entity/',
         'pretty' => 1,
 });

 # Print to output.
 print $json;

 # Output like:
 # {
 #    "type" : "time",
 #    "value" : {
 #       "after" : 0,
 #       "before" : 0,
 #       "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
 #       "precision" : 10,
 #       "time" : "+2020-09-01T00:00:00Z",
 #       "timezone" : 0
 #    }
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value qw(json2obj);

 # Time JSON structure.
 my $json = <<'END';
 {
    "type" : "time",
    "value" : {
       "after" : 0,
       "before" : 0,
       "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
       "precision" : 10,
       "time" : "+2020-09-01T00:00:00Z",
       "timezone" : 0
    }
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get calendar model.
 my $calendarmodel = $obj->calendarmodel;

 # Get precision.
 my $precision = $obj->precision;

 # Get type.
 my $type = $obj->type;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Calendar model: $calendarmodel\n";
 print "Precision: $precision\n";
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Calendar model: Q1985727
 # Precision: 10
 # Type: time
 # Value: +2020-09-01T00:00:00Z

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::JSON::Value::Globecoordinate>,
L<Wikibase::Datatype::JSON::Value::Item>,
L<Wikibase::Datatype::JSON::Value::Monolingual>,
L<Wikibase::Datatype::JSON::Value::Property>,
L<Wikibase::Datatype::JSON::Value::Quantity>,
L<Wikibase::Datatype::JSON::Value::String>,
L<Wikibase::Datatype::JSON::Value::Time>,
L<Wikibase::Datatype::Struct::Value::Globecoordinate>,
L<Wikibase::Datatype::Struct::Value::Item>,
L<Wikibase::Datatype::Struct::Value::Monolingual>,
L<Wikibase::Datatype::Struct::Value::Property>,
L<Wikibase::Datatype::Struct::Value::Quantity>,
L<Wikibase::Datatype::Struct::Value::String>,
L<Wikibase::Datatype::Struct::Value::Time>,
L<Wikibase::Datatype::Value>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase JSON structure serialization.

=item L<Wikibase::Datatype::Value::Globecoordinate>

Wikibase globe coordinate value datatype.

=item L<Wikibase::Datatype::Value::Item>

Wikibase item value datatype.

=item L<Wikibase::Datatype::Value::Monolingual>

Wikibase monolingual value datatype.

=item L<Wikibase::Datatype::Value::Property>

Wikibase property value datatype.

=item L<Wikibase::Datatype::Value::Quantity>

Wikibase quantity value datatype.

=item L<Wikibase::Datatype::Value::String>

Wikibase string value datatype.

=item L<Wikibase::Datatype::Value::Time>

Wikibase time value datatype.

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

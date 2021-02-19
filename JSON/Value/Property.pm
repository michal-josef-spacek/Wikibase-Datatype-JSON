package Wikibase::Datatype::JSON::Value::Property;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::Value::Property;

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
	}, {
		'value' => {
			'entity-type' => JSON_TYPE_STRING,
			'id' => JSON_TYPE_STRING,
			'numeric-id' => JSON_TYPE_INT,
		},
		'type' => JSON_TYPE_STRING,
	});

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	if (! exists $struct_hr->{'type'}
		|| ! defined $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'wikibase-entityid'
		|| ! exists $struct_hr->{'value'}
		|| ! exists $struct_hr->{'value'}->{'entity-type'}
		|| ! defined $struct_hr->{'value'}->{'entity-type'}
		|| $struct_hr->{'value'}->{'entity-type'} ne 'property') {

		err "Structure isn't for 'property' datatype.";
	}

	my $obj = Wikibase::Datatype::Value::Property->new(
		'value' => $struct_hr->{'value'}->{'id'},
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::Property - Wikibase property JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value::Property qw(obj2json json2obj);

 my $struct_hr = obj2json($obj);
 my $obj = json2obj($struct_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $struct_hr = obj2json($obj);

Convert Wikibase::Datatype::Value::Property instance to structure.

Returns reference to hash with structure.

=head2 C<json2obj>

 my $obj = json2obj($struct_hr);

Convert structure of property to object.

Returns Wikibase::Datatype::Value::Property instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::Property'.

 json2obj():
         Structure isn't for 'property' datatype.

=head1 EXAMPLE1

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

=head1 EXAMPLE2

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

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
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

© Michal Josef Špaček 2021

BSD 2-Clause License

=head1 VERSION

0.01

=cut

package Wikibase::Datatype::JSON::Value::String;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::Value::String;

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
	if (! $obj->isa('Wikibase::Datatype::Value::String')) {
		err "Object isn't 'Wikibase::Datatype::Value::String'.";
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $json = $json_o->encode({
		'type' => $obj->type,
		'value' => $obj->value,
	}, {
		'type' => JSON_TYPE_STRING,
		'value' => JSON_TYPE_STRING,
	});

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	if (! exists $struct_hr->{'type'}
		|| $struct_hr->{'type'} ne 'string') {

		err "Structure isn't for 'string' datatype.";
	}

	my $obj = Wikibase::Datatype::Value::String->new(
		'value' => $struct_hr->{'value'},
	);

	return $obj;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::String - Wikibase string JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value::String qw(obj2json json2obj);

 my $json = obj2json($obj, $opts_hr);
 my $obj = json2obj($json);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Value::String instance to structure.
C<$opts_hr> are optional settings. There is 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert structure of JSON string to object.

Returns Wikibase::Datatype::Value::String instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::String'.

 json2obj():
         Structure isn't for 'string' datatype.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Data::Printer;
 use Wikibase::Datatype::Value::String;
 use Wikibase::Datatype::JSON::Value::String qw(obj2json);

 # Object.
 my $obj = Wikibase::Datatype::Value::String->new(
         'value' => 'foo',
 );

 # Get JSON string.
 my $json = obj2json($obj, {'pretty' => 1});

 # Print out.
 print $json;

 # Output:
 # {
 #    "value" : "foo",
 #    "type" : "string"
 # }

=head1 EXAMPLE2

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::String qw(json2obj);

 # JSON structure.
 my $json = <<'END';
 {
    "value" : "foo",
    "type" : "string"
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get type.
 my $type = $obj->type;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Type: $type\n";
 print "Value: $value\n";

 # Output:
 # Type: string
 # Value: foo

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::Value::String>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase JSON structure serialization.

=item L<Wikibase::Datatype::Value::String>

Wikibase string value datatype.

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

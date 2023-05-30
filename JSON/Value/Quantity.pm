package Wikibase::Datatype::JSON::Value::Quantity;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use URI;
use Wikibase::Datatype::Struct::Value::Quantity;
use Wikibase::Datatype::Value::Quantity;

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
	if (! $obj->isa('Wikibase::Datatype::Value::Quantity')) {
		err "Object isn't 'Wikibase::Datatype::Value::Quantity'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $amount = $obj->value;
	$amount = _add_plus($amount);

	my $unit;
	if (defined $obj->unit) {
		$unit = $opts_hr->{'base_uri'}.$obj->unit;
	} else {
		$unit = 1;
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $json = $json_o->encode({
		'value' => {
			'amount' => $amount,
			defined $obj->lower_bound ? (
				'lowerBound' => _add_plus($obj->lower_bound),
			) : (),
			'unit' => $unit,
			defined $obj->upper_bound ? (
				'upperBound' => _add_plus($obj->upper_bound),
			) : (),
		},
		'type' => $obj->type,
	}, json_type());

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	return Wikibase::Datatype::Struct::Value::Quantity::struct2obj($struct_hr);
}

sub json_type {
	return {
		'value' => {
			'amount' => JSON_TYPE_STRING,
			'lowerBound' => JSON_TYPE_STRING,
			'unit' => JSON_TYPE_STRING,
			'upperBound' => JSON_TYPE_STRING,
		},
		'type' => JSON_TYPE_STRING,
	};
}

sub _add_plus {
	my $value = shift;

	if ($value =~ m/^\d+$/) {
		$value = '+'.$value;
	}

	return $value;
}

sub _remove_plus {
	my $value = shift;

	if ($value =~ m/^\+(\d+)$/ms) {
		$value = $1;
	}

	return $value;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::Quantity - Wikibase quantity JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value::Quantity qw(obj2json json2obj);

 my $json = obj2json($obj, $opts_hr);
 my $obj = json2obj($json);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Value::Quantity instance to structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of quantity to object.

Returns Wikibase::Datatype::Value::Quantity instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::Quantity'.
         Parameter 'base_uri' is required.

 json2obj():
         From Wikibase::Datatype::Struct::Value::Quantity::struct2obj():
                 Structure isn't for 'quantity' datatype.

=head1 EXAMPLE1

=for comment filename=value_quantity_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::Value::Quantity;
 use Wikibase::Datatype::JSON::Value::Quantity qw(obj2json);

 # Object.
 my $obj = Wikibase::Datatype::Value::Quantity->new(
         'unit' => 'Q190900',
         'value' => 10,
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
 #       "amount" : "+10",
 #       "unit" : "http://test.wikidata.org/entity/Q190900"
 #    },
 #    "type" : "quantity"
 # }

=head1 EXAMPLE2

=for comment filename=value_quantity_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::Quantity qw(json2obj);

 # Quantity structure.
 my $json = <<'END';
 {
    "value" : {
       "amount" : "+10",
       "unit" : "http://test.wikidata.org/entity/Q190900"
    },
    "type" : "quantity"
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get type.
 my $type = $obj->type;

 # Get unit.
 my $unit = $obj->unit;

 # Get value.
 my $value = $obj->value;

 # Print out.
 print "Type: $type\n";
 if (defined $unit) {
         print "Unit: $unit\n";
 }
 print "Value: $value\n";

 # Output:
 # Type: quantity
 # Unit: Q190900
 # Value: 10

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<URI>,
L<Wikibase::Datatype::Struct::Value::Quantity>,
L<Wikibase::Datatype::Value::Property>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase JSON structure serialization.

=item L<Wikibase::Datatype::Value::Quantity>

Wikibase quantity value datatype.

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

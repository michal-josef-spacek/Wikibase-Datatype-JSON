package Wikibase::Datatype::JSON::Value::Time;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use URI;
use Wikibase::Datatype::Struct::Value::Time;
use Wikibase::Datatype::Value::Time;

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
	if (! $obj->isa('Wikibase::Datatype::Value::Time')) {
		err "Object isn't 'Wikibase::Datatype::Value::Time'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $calendar_model = $opts_hr->{'base_uri'}.$obj->calendarmodel;

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $json = $json_o->encode({
		'value' => {
			'after' => $obj->after,
			'before' => $obj->before,
			'calendarmodel' => $calendar_model,
			'precision' => $obj->precision,
			'time' => $obj->value,
			'timezone' => $obj->timezone,
		},
		'type' => $obj->type,
	}, json_type());

	return $json;
}

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	return Wikibase::Datatype::Struct::Value::Time::struct2obj($struct_hr);
}

sub json_type {
	return {
		'value' => {
			'after' => JSON_TYPE_INT,
			'before' => JSON_TYPE_INT,
			'calendarmodel' => JSON_TYPE_STRING,
			'precision' => JSON_TYPE_INT,
			'time' => JSON_TYPE_STRING,
			'timezone' => JSON_TYPE_INT,
		},
		'type' => JSON_TYPE_STRING,
	};
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Value::Time - Wikibase time JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Value::Time qw(obj2json json2obj);

 my $json = obj2json($obj, $opts_hr);
 my $obj = json2obj($json);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Value::Time instance to JSON structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of time to object.

Returns Wikibase::Datatype::Value::Time instance.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Value::Time'.
         Parameter 'base_uri' is required.

 json2obj():
         From Wikibase::Datatype::Struct::Value::Time::struct2obj():
                 Structure isn't for 'time' datatype.

=head1 EXAMPLE1

=for comment filename=value_time_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::Value::Time;
 use Wikibase::Datatype::JSON::Value::Time qw(obj2json);

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

 # Output:
 # {
 #    "type" : "time",
 #    "value" : {
 #       "timezone" : 0,
 #       "before" : 0,
 #       "precision" : 10,
 #       "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
 #       "time" : "+2020-09-01T00:00:00Z",
 #       "after" : 0
 #    }
 # }

=head1 EXAMPLE2

=for comment filename=value_string_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Value::Time qw(json2obj);

 # Time structure.
 my $json = <<'END';
 {
    "type" : "time",
    "value" : {
       "timezone" : 0,
       "before" : 0,
       "precision" : 10,
       "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
       "time" : "+2020-09-01T00:00:00Z",
       "after" : 0
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
L<URL>,
L<Wikibase::Datatype::Struct::Value::Time>
L<Wikibase::Datatype::Value::Time>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase JSON structure serialization.

=item L<Wikibase::Datatype::Value::Time>

Wikibase time value datatype.

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

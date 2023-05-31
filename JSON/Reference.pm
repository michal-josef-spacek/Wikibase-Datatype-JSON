package Wikibase::Datatype::JSON::Reference;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::JSON::Snak;
use Wikibase::Datatype::Reference;
use Wikibase::Datatype::Struct::Snak;
use Wikibase::Datatype::Struct::Reference;

Readonly::Array our @EXPORT_OK => qw(json2obj json_type obj2json);

our $VERSION = 0.01;

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	my @snaks;
	foreach my $pid (@{$struct_hr->{'snaks-order'}}) {
		foreach my $snak_hr (@{$struct_hr->{'snaks'}->{$pid}}) {
			push @snaks, Wikibase::Datatype::Struct::Snak::struct2obj($snak_hr);
		}
	}
	my $obj = Wikibase::Datatype::Reference->new(
		'snaks' => \@snaks,
	);

	return $obj;
}

sub json_type {
	my $obj = shift;

	return {
		'snaks' => {
			map { ($_->property => [Wikibase::Datatype::JSON::Snak::json_type($_)]) } @{$obj->snaks},
		},
		'snaks-order' => json_type_arrayof(JSON_TYPE_STRING),
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
	if (! $obj->isa('Wikibase::Datatype::Reference')) {
		err "Object isn't 'Wikibase::Datatype::Reference'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	my $json = $json_o->encode(
		Wikibase::Datatype::Struct::Reference::obj2struct($obj, $opts_hr->{'base_uri'}),
		json_type($obj),
	);

	return $json;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Reference - Wikibase reference JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Reference qw(json2obj json_type obj2json);

 my $obj = json2obj($json);
 my $json_type_hr = json_type($obj);
 my $json = obj2json($obj, $opts_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of reference to object.

Returns Wikibase::Datatype::Reference instance.

=head2 C<json_type>

 my $json_type_hr = json_type($obj);

Get JSON type defined in L<Cpanel::JSON::XS::Type>.

Returns reference to hash.

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Reference instance to JSON structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Reference'.
         Parameter 'base_uri' is required.

=head1 EXAMPLE1

=for comment filename=reference_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Reference qw(json2obj);

 # Reference JSON structure.
 my $json = <<'END';
 {
    "snaks" : {
       "P854" : [
          {
             "property" : "P854",
             "snaktype" : "value",
             "datavalue" : {
                "value" : "https://skim.cz",
                "type" : "string"
             },
             "datatype" : "url"
          }
       ],
       "P813" : [
          {
             "datavalue" : {
                "type" : "time",
                "value" : {
                   "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
                   "time" : "+2013-12-07T00:00:00Z",
                   "precision" : 11,
                   "timezone" : 0,
                   "after" : 0,
                   "before" : 0
                }
             },
             "datatype" : "time",
             "property" : "P813",
             "snaktype" : "value"
          }
       ]
    },
    "snaks-order" : [
       "P854",
       "P813"
    ]
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Get value.
 my $snaks_ar = $obj->snaks;

 # Print out.
 print "Number of snaks: ".@{$snaks_ar}."\n";

 # Output:
 # Number of snaks: 2

=head1 EXAMPLE2

=for comment filename=reference_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Reference qw(obj2json);
 use Wikibase::Datatype::Reference;
 use Wikibase::Datatype::Value::Item;

 # Object.
 # instance of (P31) human (Q5)
 my $obj = Wikibase::Datatype::Reference->new(
          'snaks' => [
                  Wikibase::Datatype::Snak->new(
                          'datatype' => 'url',
                          'datavalue' => Wikibase::Datatype::Value::String->new(
                                  'value' => 'https://skim.cz',
                          ),
                          'property' => 'P854',
                  ),
                  Wikibase::Datatype::Snak->new(
                          'datatype' => 'time',
                          'datavalue' => Wikibase::Datatype::Value::Time->new(
                                  'value' => '+2013-12-07T00:00:00Z',
                          ),
                          'property' => 'P813',
                  ),
          ],
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
 #    "snaks" : {
 #       "P854" : [
 #          {
 #             "property" : "P854",
 #             "snaktype" : "value",
 #             "datavalue" : {
 #                "value" : "https://skim.cz",
 #                "type" : "string"
 #             },
 #             "datatype" : "url"
 #          }
 #       ],
 #       "P813" : [
 #          {
 #             "datavalue" : {
 #                "type" : "time",
 #                "value" : {
 #                   "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
 #                   "time" : "+2013-12-07T00:00:00Z",
 #                   "precision" : 11,
 #                   "timezone" : 0,
 #                   "after" : 0,
 #                   "before" : 0
 #                }
 #             },
 #             "datatype" : "time",
 #             "property" : "P813",
 #             "snaktype" : "value"
 #          }
 #       ]
 #    },
 #    "snaks-order" : [
 #       "P854",
 #       "P813"
 #    ]
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

=item L<Wikibase::Datatype::Reference>

Wikibase reference datatype.

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

package Wikibase::Datatype::JSON::Statement;

use base qw(Exporter);
use strict;
use warnings;

use Cpanel::JSON::XS;
use Cpanel::JSON::XS::Type;
use Error::Pure qw(err);
use Readonly;
use Wikibase::Datatype::Statement;
use Wikibase::Datatype::Struct::Reference;
use Wikibase::Datatype::Struct::Snak;
use Wikibase::Datatype::Struct::Statement;
use Wikibase::Datatype::JSON::Reference;
use Wikibase::Datatype::JSON::Snak;

Readonly::Array our @EXPORT_OK => qw(json2obj json_type obj2json);

our $VERSION = 0.01;

sub json2obj {
	my $json = shift;

	my $struct_hr = Cpanel::JSON::XS->new->decode($json);

	my @property_snaks;
	foreach my $pid (@{$struct_hr->{'qualifiers-order'}}) {
		foreach my $snak_hr (@{$struct_hr->{'qualifiers'}->{$pid}}) {
			push @property_snaks, Wikibase::Datatype::Struct::Snak::struct2obj($snak_hr);
		}
	}

	return Wikibase::Datatype::Statement->new(
		'id' => $struct_hr->{'id'},
		'property_snaks' => \@property_snaks,
		'rank' => $struct_hr->{'rank'},
		'references' => [map { Wikibase::Datatype::Struct::Reference::struct2obj($_) } @{$struct_hr->{'references'}}],
		'snak' => Wikibase::Datatype::Struct::Snak::struct2obj($struct_hr->{'mainsnak'}),
	);
}

sub json_type {
	my $obj = shift;

	return {
		'id' => JSON_TYPE_STRING,
		'mainsnak' => Wikibase::Datatype::JSON::Snak::json_type($obj->snak),
		'qualifiers' => {
			map { ($_->property => [Wikibase::Datatype::JSON::Snak::json_type($_)]) } @{$obj->property_snaks},
		},
		'qualifiers-order' => json_type_arrayof(JSON_TYPE_STRING),
		'rank' => JSON_TYPE_STRING,
		'references' => [map { Wikibase::Datatype::JSON::Reference::json_type($_) } @{$obj->references}],
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
	if (! $obj->isa('Wikibase::Datatype::Statement')) {
		err "Object isn't 'Wikibase::Datatype::Statement'.";
	}

	if (! exists $opts_hr->{'base_uri'} || ! defined $opts_hr->{'base_uri'}) {
		err "Parameter 'base_uri' is required.";
	}

	my $json_o = Cpanel::JSON::XS->new;
	if ($opts_hr->{'pretty'}) {
		$json_o = $json_o->pretty;
	}

	return $json_o->encode(
		Wikibase::Datatype::Struct::Statement::obj2struct($obj, $opts_hr->{'base_uri'}),
		json_type($obj),
	);
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikibase::Datatype::JSON::Statement - Wikibase statement JSON structure serialization.

=head1 SYNOPSIS

 use Wikibase::Datatype::JSON::Statement qw(json2obj json_type obj2json);

 my $obj = json2obj($json);
 my $json_type_hr = json_type($obj);
 my $json = obj2json($obj, $opts_hr);

=head1 DESCRIPTION

This conversion is between objects defined in Wikibase::Datatype and structures
serialized via JSON to MediaWiki.

=head1 SUBROUTINES

=head2 C<json2obj>

 my $obj = json2obj($json);

Convert JSON structure of statement to object.

Returns Wikibase::Datatype::Statement instance.

=head2 C<json_type>

 my $json_type_hr = json_type($obj);

Get JSON type defined in L<Cpanel::JSON::XS::Type>.

Returns reference to hash.

=head2 C<obj2json>

 my $json = obj2json($obj, $opts_hr);

Convert Wikibase::Datatype::Statement instance to JSON structure.
C<$opts_hr> is reference to hash with parameters:

 'base_uri' is base URI of Wikibase system (e.g. http://test.wikidata.org/entity/).
 'pretty' flag for pretty print (0/1).

Returns JSON string.

=head1 ERRORS

 obj2json():
         Object doesn't exist.
         Object isn't 'Wikibase::Datatype::Statement'.
         Parameter 'base_uri' is required.

=head1 EXAMPLE1

=for comment filename=statement_json2obj.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Statement qw(json2obj);

 # Snak JSON structure.
 my $json = <<'END';
 {
   "id":"Q1234$1E0D43AE-0084-11EE-9F73-54E1ADF06DAE",
   "rank":"normal",
   "references":[{
     "snaks-order":[
       "P248",
       "P214",
       "P813"
     ],
     "snaks":{
       "P214":[{
         "datatype":"external-id",
         "datavalue":{
           "value":"113230702",
           "type":"string"
         },
         "snaktype":"value",
         "property":"P214"
       }],
       "P248":[{
         "property":"P248",
         "snaktype":"value",
         "datatype":"wikibase-item",
         "datavalue":{
           "value":{
             "id":"Q53919",
             "entity-type":"item",
             "numeric-id":53919
           },
           "type":"wikibase-entityid"
         }
       }],
       "P813":[{
         "snaktype":"value",
         "property":"P813",
         "datatype":"time",
         "datavalue":{
           "value":{
             "calendarmodel":"https://test.wikidata.org/entity/Q1985727",
             "timezone":0,
             "after":0,
             "precision":11,
             "time":"+2013-12-07T00:00:00Z",
             "before":0
           },
           "type":"time"
         }
       }]
     }
   }],
   "qualifiers":{
     "P642":[{
       "datavalue":{
         "type":"wikibase-entityid",
         "value":{
           "numeric-id":5185279,
           "entity-type":"item",
           "id":"Q5185279"
         }
       },
       "datatype":"wikibase-item",
       "property":"P642",
       "snaktype":"value"
     }]
   },
   "qualifiers-order":[
     "P642"
   ],
   "mainsnak":{
     "snaktype":"value",
     "property":"P31",
     "datatype":"wikibase-item",
     "datavalue":{
       "value":{
         "numeric-id":3331189,
         "entity-type":"item",
         "id":"Q3331189"
       },
       "type":"wikibase-entityid"
     }
   },
   "type":"statement"
 }
 END

 # Get object.
 my $obj = json2obj($json);

 # Print out.
 print 'Id: '.$obj->id."\n";
 print 'Claim: '.$obj->snak->property.' -> '.$obj->snak->datavalue->value."\n";
 print "Qualifiers:\n";
 foreach my $property_snak (@{$obj->property_snaks}) {
         print "\t".$property_snak->property.' -> '.
                 $property_snak->datavalue->value."\n";
 }
 print "References:\n";
 foreach my $reference (@{$obj->references}) {
         print "\tReference:\n";
         foreach my $reference_snak (@{$reference->snaks}) {
                 print "\t\t".$reference_snak->property.' -> '.
                         $reference_snak->datavalue->value."\n";
         }
 }
 print 'Rank: '.$obj->rank."\n";

 # Output:
 # Id: Q1234$1E0D43AE-0084-11EE-9F73-54E1ADF06DAE
 # Claim: P31 -> Q3331189
 # Qualifiers:
 #         P642 -> Q5185279
 # References:
 #         Reference:
 #                 P248 -> Q53919
 #                 P214 -> 113230702
 #                 P813 -> +2013-12-07T00:00:00Z
 # Rank: normal

=head1 EXAMPLE2

=for comment filename=statement_obj2json_pretty.pl

 use strict;
 use warnings;

 use Wikibase::Datatype::JSON::Statement qw(obj2json);
 use Wikibase::Datatype::Reference;
 use Wikibase::Datatype::Snak;
 use Wikibase::Datatype::Statement;
 use Wikibase::Datatype::Value::Item;
 use Wikibase::Datatype::Value::String;
 use Wikibase::Datatype::Value::Time;

 # Object.
 my $obj = Wikibase::Datatype::Statement->new(
         'id' => 'Q123$00C04D2A-49AF-40C2-9930-C551916887E8',

         # instance of (P31) human (Q5)
         'snak' => Wikibase::Datatype::Snak->new(
                  'datatype' => 'wikibase-item',
                  'datavalue' => Wikibase::Datatype::Value::Item->new(
                          'value' => 'Q5',
                  ),
                  'property' => 'P31',
         ),
         'property_snaks' => [
                 # of (P642) alien (Q474741)
                 Wikibase::Datatype::Snak->new(
                          'datatype' => 'wikibase-item',
                          'datavalue' => Wikibase::Datatype::Value::Item->new(
                                  'value' => 'Q474741',
                          ),
                          'property' => 'P642',
                 ),
         ],
         'references' => [
                  Wikibase::Datatype::Reference->new(
                          'snaks' => [
                                  # stated in (P248) Virtual International Authority File (Q53919)
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'wikibase-item',
                                           'datavalue' => Wikibase::Datatype::Value::Item->new(
                                                   'value' => 'Q53919',
                                           ),
                                           'property' => 'P248',
                                  ),

                                  # VIAF ID (P214) 113230702
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'external-id',
                                           'datavalue' => Wikibase::Datatype::Value::String->new(
                                                   'value' => '113230702',
                                           ),
                                           'property' => 'P214',
                                  ),

                                  # retrieved (P813) 7 December 2013
                                  Wikibase::Datatype::Snak->new(
                                           'datatype' => 'time',
                                           'datavalue' => Wikibase::Datatype::Value::Time->new(
                                                   'value' => '+2013-12-07T00:00:00Z',
                                           ),
                                           'property' => 'P813',
                                  ),
                          ],
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
 #    "qualifiers-order" : [
 #       "P642"
 #    ],
 #    "qualifiers" : {
 #       "P642" : [
 #          {
 #             "datavalue" : {
 #                "value" : {
 #                   "numeric-id" : 474741,
 #                   "id" : "Q474741",
 #                   "entity-type" : "item"
 #                },
 #                "type" : "wikibase-entityid"
 #             },
 #             "snaktype" : "value",
 #             "datatype" : "wikibase-item",
 #             "property" : "P642"
 #          }
 #       ]
 #    },
 #    "id" : "Q123$00C04D2A-49AF-40C2-9930-C551916887E8",
 #    "rank" : "normal",
 #    "type" : "statement",
 #    "references" : [
 #       {
 #          "snaks" : {
 #             "P248" : [
 #                {
 #                   "datatype" : "wikibase-item",
 #                   "property" : "P248",
 #                   "snaktype" : "value",
 #                   "datavalue" : {
 #                      "type" : "wikibase-entityid",
 #                      "value" : {
 #                         "numeric-id" : 53919,
 #                         "id" : "Q53919",
 #                         "entity-type" : "item"
 #                      }
 #                   }
 #                }
 #             ],
 #             "P214" : [
 #                {
 #                   "property" : "P214",
 #                   "datatype" : "external-id",
 #                   "snaktype" : "value",
 #                   "datavalue" : {
 #                      "type" : "string",
 #                      "value" : "113230702"
 #                   }
 #                }
 #             ],
 #             "P813" : [
 #                {
 #                   "snaktype" : "value",
 #                   "property" : "P813",
 #                   "datatype" : "time",
 #                   "datavalue" : {
 #                      "type" : "time",
 #                      "value" : {
 #                         "time" : "+2013-12-07T00:00:00Z",
 #                         "after" : 0,
 #                         "calendarmodel" : "http://test.wikidata.org/entity/Q1985727",
 #                         "before" : 0,
 #                         "precision" : 11,
 #                         "timezone" : 0
 #                      }
 #                   }
 #                }
 #             ]
 #          },
 #          "snaks-order" : [
 #             "P248",
 #             "P214",
 #             "P813"
 #          ]
 #       }
 #    ],
 #    "mainsnak" : {
 #       "property" : "P31",
 #       "datatype" : "wikibase-item",
 #       "snaktype" : "value",
 #       "datavalue" : {
 #          "value" : {
 #             "numeric-id" : 5,
 #             "entity-type" : "item",
 #             "id" : "Q5"
 #          },
 #          "type" : "wikibase-entityid"
 #       }
 #    }
 # }

=head1 DEPENDENCIES

L<Cpanel::JSON::XS>,
L<Cpanel::JSON::XS::Type>,
L<Error::Pure>,
L<Exporter>,
L<Readonly>,
L<Wikibase::Datatype::Statement>,
L<Wikibase::Datatype::Struct::Reference>,
L<Wikibase::Datatype::Struct::Snak>,
L<Wikibase::Datatype::Struct::Statement>,
L<Wikibase::Datatype::JSON::Reference>,
L<Wikibase::Datatype::JSON::Snak>.

=head1 SEE ALSO

=over

=item L<Wikibase::Datatype::JSON>

Wikibase structure JSON serialization.

=item L<Wikibase::Datatype::Statement>

Wikibase statement datatype.

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

use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Wikibase structure JSON serialization.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.05;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Wikibase-Datatype-JSON';
perl_version 5.010;
readme_from 'JSON.pm';
recursive_author_tests('xt');
requires 'Class::Utils' => 0.03;
requires 'Cpanel::JSON::XS' => 0;
requires 'Error::Pure' => 0.15;
requires 'Exporter' => 0;
requires 'List::MoreUtils' => 0;
requires 'Readonly' => 0;
requires 'URI' => 0;
requires 'Wikibase::Datatype' => 0.07;
requires 'Wikibase::Datatype::Struct' => 0.08;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Wikibase-Datatype-JSON/issues',
resources 'homepage' => 'https://github.com/michal-josef-spacek/Wikibase-Datatype-JSON';
resources 'repository' => 'git://github.com/michal-josef-spacek/Wikibase-Datatype-JSON';
test_requires 'English' => 0;
test_requires 'Error::Pure::Utils' => 0;
test_requires 'Test::JSON::Type' => 0.03;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
test_requires 'Unicode::UTF8' => 0;
test_requires 'Wikibase::Datatype' => 0.03;
tests_recursive;
version '0.01';

# Run.
WriteAll();

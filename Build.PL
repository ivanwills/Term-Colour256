use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'Term::Colour256',
    license           => 'perl',
    dist_author       => 'dev <dev@localhost>',
    dist_version_from => 'lib/Term/Colour256.pm',
    requires          => {
        'perl'             => 5.008,
    },
    configure_requires => {
        'Module::Build' => 0.38,
    },
    build_requires => {
        'Test::More'       => 0,
        'Test::NoWarnings' => 0,
    },
    add_to_cleanup     => [ 'Term-Colour256-*' ],
    create_makefile_pl => 'traditional',
    create_license     => 1,
    meta_merge => {
        resources => {
            repository => 'git://github.com/ivanwills/Term-Colour256.git',
            bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Term::Colour256',
        },
    },
);

$builder->create_build_script();

#!/usr/bin/perl -w

use 5.10.0;

use strict;
use Module::Build;

my $builder = Module::Build->new(
    module_name => 'Object::ID',
    license     => 'perl',
    dist_author => 'Michael G Schwern <schwern@pobox.com>',

    no_index => {
        package => [
            "UNIVERSAL"
        ],
    },

    meta_merge  => {
        resources => {
            repository =>
              'http://github.com/schwern/Object-ID',
        },

        keywords => [ 'id', 'identifier', 'universal', 'object' ],

        configure_requires => {
            'Module::Build'     => 0.340201     # what shipped with 5.10.1
        },
    },

    build_requires      => {
        'Test::More'        => 0.88,    # for done_testing
    },

    requires             => {
        perl            => '5.10.0',    # for Hash::Util::FieldHash
    },

    auto_features => {
        object_uuid     => {
            description => "Unique object idenifier using UUIDs",
            requires    => {
                "Data::UUID" => 1.148
            }
        }
    },

    create_license      => 1,
    create_readme       => 1,
);

$builder->create_build_script();

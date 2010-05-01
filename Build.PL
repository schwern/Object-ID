#!/usr/bin/perl -w

use 5.10.0;  # Need Hash::Util::FieldHash

use strict;
use Module::Build;

my $builder = Module::Build->new(
    module_name => 'Object::ID',
    license     => 'perl',

    meta_merge  => {
        resources => {
            repository =>
              'http://github.com/schwern/Object-ID',
        },

        keywords => [ 'id', 'identifier', 'universal', 'object' ],

        configure_requires => {
            'Module::Build'     => 0.2808
        },
    },

    build_requires      => {
        'Test::More'        => 0.72,
    },

    requires             => {
    },
);

$builder->create_build_script();

#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;

{
    package My::Class;

    sub new {
        my $class = shift;
        bless {}, $class;
    }
}

use UNIVERSAL::Object::ID;

# Is it universal?
{
    my $obj = new_ok "My::Class";
    ok $obj->object_id;
}

# What about a totally unrelated module?
{
    use Time::Piece;
    my $time = gmtime;
    ok $time->object_id;

    my $time2 = gmtime;
    ok $time2->object_id;

    isnt $time->object_id, $time2->object_id;
}

# A regex object?
{
    my $re = qr/foo/;
    ok $re->object_id;

    my $re2 = qr/foo/;
    isnt $re->object_id, $re2->object_id;
}


done_testing;

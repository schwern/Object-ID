package Object::ID;

use 5.10.0;

use strict;
use warnings;

use version; our $VERSION = qv("v0.0.4");

use Hash::Util::FieldHash;

# Even though we're not using Exporter, be polite for introspection purposes
our @EXPORT = qw(object_id object_uuid);

sub import {
    my $caller = caller;

    no strict 'refs';
    *{$caller.'::object_id'}   = \&object_id;
    *{$caller.'::object_uuid'} = \&object_uuid;
}


# All glory to Vincent Pit for coming up with this implementation
{
    Hash::Util::FieldHash::fieldhash(my %IDs);

    sub object_id {
        my $self = shift;

        state $last_id = "a";
        return exists $IDs{$self} ? $IDs{$self} : ($IDs{$self} = ++$last_id);
    }
}


# All glory to Vincent Pit for coming up with this implementation
{
    Hash::Util::FieldHash::fieldhash(my %UUIDs);

    sub object_uuid {
        my $self = shift;

        state $ug = eval { require Data::UUID; Data::UUID->new; };
        if( !$ug ) {
            require Carp;
            Carp::croak("object_uuid() requires Data::UUID");
        }

        return exists $UUIDs{$self} ? $UUIDs{$self} : ($UUIDs{$self} = $ug->create_str);
    }
}


=head1 NAME

Object::ID - A unique identifier for any object

=head1 SYNOPSIS

    package My::Object;

    # Imports the object_id method
    use Object::ID;


=head1 DESCRIPTION

This is a unique identifier for any object, regardless of its type,
structure or contents.  Its features are:

    * Works on ANY object of any type
    * Does not modify the object in any way
    * Does not change with the object's contents
    * Is O(1) to calculate (ie. doesn't matter how big the object is)
    * The id is unique for the life of the process


=head1 USAGE

Object::ID is a role, rather than inheriting its methods they are
imported into your class.  To make your class use Object::ID, simply
C<< use Object::ID >> in your class.

    package My::Class;

    use Object::ID;

Then write your class however you want.


=head1 METHODS

The following methods are made available to your class.

=head2 object_id

    my $id = $object->object_id;

Returns an identifier unique to the C<$object>.

The identifier is not related to the content of the object.  It is
only unique for the life of the process.  There is no guarantee as to
the format of the identifier from version to version.

For example:

    my $obj = My::Class->new;
    my $copy = $obj;

    # This is true, $obj and $copy refer to the same object
    $obj->object_id eq $copy->object_id;

    my $obj2 = My::Class->new;

    # This is false, $obj and $obj2 are different objects.
    $obj->object_id eq $obj2->object_id;

    use Clone;
    my $clone = clone($obj);

    # This is false, even though they contain the same data.
    $obj->object_id eq $clone->object_id;

=head2 object_uuid

    my $uuid = $object->object_uuid

Like C<< $object->object_id >> but returns a UUID unique to the $object.

Only works if Data::UUID is installed.

See L<Data::UUID> for more details about UUID.


=head1 FAQ

=head2 Why not just use the object's reference?

References are not unique over the life of a process.  Perl will reuse
references of destroyed objects, as demonstrated by this code snippet:

    {
        package Foo;

        sub new {
            my $class = shift;
            my $string = shift;
            return bless {}, $class;
        }
    }

    for(1..3) {
        my $obj = Foo->new;
        print "Object's reference is $obj\n";
    }

This will print, for example, C<< Object's reference is
Foo=HASH(0x803704) >> three times.


=head1 LICENSE

Copyright 2010, Michael G Schwern <schwern@pobox.com>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>


=head1 THANKS

Thank you to Vincent Pit for coming up with the implementation.

=cut

1;

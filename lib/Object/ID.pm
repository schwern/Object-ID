package Object::ID;

use 5.10.0;

use strict;
use warnings;

use version; our $VERSION = qv("v0.0.1");

our @EXPORT = qw(object_id);

sub import {
    my $caller = caller;

    no strict 'refs';
    *{$caller.'::object_id'} = \&object_id;
}

require Hash::Util::FieldHash;
Hash::Util::FieldHash::fieldhash(my %IDs);

sub object_id {
    # Use a string so we don't run out of numbers
    state $last_id = "a";

    my $self = shift;
    return exists $IDs{$self} ? $IDs{$self} : ($IDs{$self} = ++$last_id);
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
    * Does not change with the object's contents
    * Is O(1) to calculate (ie. doesn't matter how big the object is)
    * The id is unique for the life of the process


=head1 USAGE

Object::ID is a role, rather than inheriting its methods they are
imported into your class.  To make your class use Object::ID, simply
C<< use Object::ID >> in your class.

    package My::Class;

    use Object::ID;


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


=cut

1;

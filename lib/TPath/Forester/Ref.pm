package TPath::Forester::Ref;
{
  $TPath::Forester::Ref::VERSION = '0.001';
}

# ABSTRACT: TPath::Forester that understands Perl structs


use v5.10;
use Moose;
use Moose::Exporter;
use MooseX::MethodAttributes;
use namespace::autoclean;
use TPath::Forester::Ref::Node;
use TPath::Forester::Ref::Expression;

Moose::Exporter->setup_import_methods(
    as_is => [ rtree => \&rtree, tfr => \&tfr ], );


with 'TPath::Forester';

around path => sub {
    my ( $orig, $self, $expr ) = @_;
    my $path = $self->$orig($expr);
    bless $path, 'TPath::Forester::Ref::Expression';
};

sub children {
    my ( $self, $n ) = @_;
    @{ $n->children };
}

sub has_tag {
    my ( $self, $n, $tag ) = @_;
    return 0 unless defined $n->tag;
    $n->tag eq $tag;
}

sub matches_tag {
    my ( $self, $n, $re ) = @_;
    return 0 unless defined $n->tag;
    $n->tag =~ $re;
}


sub array : Attr { my ( $self, $n ) = @_; $n->type eq 'array' ? 1 : undef; }


sub obj_can : Attr(can) {
    my ( $self, $n, undef, undef, $method ) = @_;
    $n->type eq 'object' && $n->value->can($method) ? 1 : undef;
}


sub code : Attr { my ( $self, $n ) = @_; $n->type eq 'code' ? 1 : undef; }


sub obj_defined :
  Attr(defined) { my ( $self, $n ) = @_; defined $n->value ? 1 : undef; }


sub obj_does : Attr(does) {
    my ( $self, $n, undef, undef, $role ) = @_;
    $n->type eq 'object' && $n->value->does($role) ? 1 : undef;
}


sub glob : Attr { my ( $self, $n ) = @_; $n->type eq 'glob' ? 1 : undef; }


sub hash : Attr { my ( $self, $n ) = @_; $n->type eq 'hash' ? 1 : undef; }


sub obj_isa : Attr(isa) {
    my ( $self, $n, undef, undef, @classes ) = @_;
    return undef unless $n->type eq 'object';
    for my $class (@classes) {
        return 1 if $n->value->isa($class);
    }
    undef;
}


sub key : Attr { my ( $self, $n ) = @_; $n->tag; }


sub num : Attr { my ( $self, $n ) = @_; $n->type eq 'num' ? 1 : undef; }


sub obj : Attr { my ( $self, $n ) = @_; $n->type eq 'object' ? 1 : undef; }


sub is_ref : Attr(ref) { my ( $self, $n ) = @_; $n->is_ref ? 1 : undef; }


sub is_non_ref :
  Attr(non-ref) { my ( $self, $n ) = @_; $n->is_ref ? undef : 1; }


sub repeat : Attr {
    my ( $self, $n, undef, undef, $index ) = @_;
    my $reps = $n->is_repeated;
    return undef unless defined $reps;
    return $reps ? 1 : undef unless defined $index;
    $n->is_repeated == $index ? 1 : undef;
}


sub repeated :
  Attr { my ( $self, $n ) = @_; defined $n->is_repeated ? 1 : undef; }


sub is_scalar :
  Attr(scalar) { my ( $self, $n ) = @_; $n->type eq 'scalar' ? 1 : undef; }


sub str : Attr { my ( $self, $n ) = @_; $n->type eq 'string' ? 1 : undef; }


sub is_undef :
  Attr(undef) { my ( $self, $n ) = @_; $n->type eq 'undef' ? 1 : undef; }


sub rtree {
    wrap(@_);
}


sub tfr() { state $singleton = TPath::Forester::Ref->new }

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

TPath::Forester::Ref - TPath::Forester that understands Perl structs

=head1 VERSION

version 0.001

=head1 SYNOPSIS

  use TPath::Forester::Ref;
  use Data::Dumper;
  
  my $ref = {
      a => [],
      b => {
          g => undef,
          h => { i => [ { l => 3, 4 => 5 }, 2 ], k => 1 },
          c => [qw(d e f)]
      }
  };
  
  my @hashes = tfr->path(q{//@hash})->dsel($ref);
  print scalar @hashes, "\n"; # 3
  my @arrays = tfr->path(q{//@array})->dsel($ref);
  print scalar @arrays, "\n"; # 3
  print Dumper $arrays[2];
  # $VAR1 = [
  #           {
  #             'l' => 3,
  #             '4' => 5
  #           },
  #           2
  #         ];

=head1 DESCRIPTION

C<TPath::Forester::Ref> adapts L<TPath::Forester> to run-of-the-mill Perl
data structures.

=head1 METHODS

=head2 C<@array>

Whether the node is an array ref.

=head2 C<@can('method')>

Attribute that is defined if the node in question has the specified method.

=head2 C<@code>

Attribute that is defined if the node is a code reference.

=head2 C<@defined>

Attribute that is defined if the node is a defined value.

=head2 C<@does('role')>

Attribute that is defined if the node does the specified role.

=head2 C<@glob>

Attribute that is defined if the node is a glob reference.

=head2 C<@hash>

Attribute that is defined if the node is a hash reference.

=head2 C<@isa('Foo','Bar')>

Attribute that is defined if the node instantiates any of the specified classes.

=head2 C<@key>

Attribute that returns the hash key, if any, associated with the node value.

=head2 C<@num>

Attribute defined for nodes whose value looks like a number according to L<Scalar::Util>.

=head2 C<@obj>

Attribute that is defined for nodes holding objects.

=head2 C<@ref>

Attribute defined for nodes holding references such as C<{}> or C<[]>.

=head2 C<@non-ref>

Attribute that is defined for nodes holding non-references -- C<undef>, strings,
or numbers.

=head2 C<@repeat> or C<@repeat(1)>

Attribute that is defined if the node holds a reference that has occurs earlier
in the tree. If a parameter is supplied, it is defined if the node in question
is the specified repetition of the reference, where the first instance is repetition
0.

=head2 C<@repeated>

Attribute that is defined for any node holding a reference that occurs more than once
in the tree.

=head2 C<@scalar>

Attribute that is defined for any node holding a scalar reference.

=head2 C<@str>

Attribute that is defined for any node holding a string.

=head2 C<@undef>

Attribute that is defined for any node holding the C<undef> value.

=head1 FUNCTIONS

=head2 rtree

Takes a reference and converts it into a tree.

  my $tree = TPath::Forester::Ref::Node->wrap(
      { foo => bar, baz => [qw(1 2 3 4)], qux => { quux => { corge => undef } } }
  );

=head2 tfr

Returns singleton C<TPath::Forester::Ref>.

=head1 ROLES

L<TPath::Forester>

=head1 AUTHOR

David F. Houghton <dfhoughton@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by David F. Houghton.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

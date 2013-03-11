package TPath::Forester::Ref::Expression;
{
  $TPath::Forester::Ref::Expression::VERSION = '0.001';
}

# ABSTRACT: expression that converts a ref into a L<TPath::Forester::Ref::Root> before walking it


use Moose;
use namespace::autoclean;
use TPath::Forester::Ref::Node;
use Scalar::Util qw(blessed);

extends 'TPath::Expression';

sub select {
    my ( $self, $node ) = @_;
    $node = wrap($node)
      unless blessed($node) && $node->isa('TPath::Forester::Ref::Node');
    $self->SUPER::select($node);
}


sub dsel {
    my ( $self, $node ) = @_;
    map { $_->value } $self->select($node);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

TPath::Forester::Ref::Expression - expression that converts a ref into a L<TPath::Forester::Ref::Root> before walking it

=head1 VERSION

version 0.001

=head1 DESCRIPTION

A L<TPath::Expression> that will automatically convert plain references like
C<{ foo => [ 'a', 'b', 'c' ], bar => 1 }> into a L<TPath::Forester::Ref::Node>
tree. These expressions can also be used on C<TPath::Forester::Ref::Node> trees
directly.

=head1 METHODS

=head2 dsel

Returns the values selected by the path as opposed to the nodes containing
them.

=head1 AUTHOR

David F. Houghton <dfhoughton@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by David F. Houghton.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

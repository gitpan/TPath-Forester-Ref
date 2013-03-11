# tests sugar functions exported by TPath::Forester::Ref

use strict;
use warnings;
use Test::More tests => 5;
use TPath::Forester::Ref;

my $ref = {
    a => 'b',
    c => [ 1, { foo => 'bar' } ]
};

my $tree = rtree $ref;
ok defined $tree, 'rtree wraps a ref';

my $index = tfr->index($tree);
ok defined $index, 'able to index wrapped tree';

my @nodes = tfr->path(q{//*})->dsel($tree);
is @nodes, 6, 'found correct number of nodes using dsel';
is $nodes[0], 'b', 'correct first node from dsel';
is ref $nodes[-1], 'HASH', 'correct last node from dsel';

done_testing();

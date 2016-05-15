#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 2;
use FindBin qw($Bin);
use lib "$Bin/../..";
use Scalar::Util qw(blessed);
use BinaryTree;

subtest 'not exist' => sub {
    plan tests => 1;
    my $tree = _build_simple_tree();
    my $node = $tree->find(2);
    is($node, undef, '');
};

subtest 'exist value' => sub {
    plan tests => 2;
    my $tree = _build_simple_tree();
    my $node = $tree->find(49);
    is($node->val, 49, 'found right value');
    $node = $tree->find(4);
    is($node->val, 4, 'found left value');
};

sub _build_simple_tree {
    my $tree = BinaryTree->new();
    my $node;
    for (1..8) {
        ($tree, $node) = $tree->add($_*$_);
    }
    return $tree;
}

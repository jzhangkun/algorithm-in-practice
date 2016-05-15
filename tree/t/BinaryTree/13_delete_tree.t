#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 4;
use FindBin qw($Bin);
use lib "$Bin/../..";
use Scalar::Util qw(blessed);
use BinaryTree;

subtest 'not exist' => sub {
    plan tests => 2;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->delete(2);
    is_deeply($new, $tree, 'same tree');
    is($node, undef, 'not found');
};

subtest 'left most' => sub {
    plan tests => 3;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->delete(1);
    my $ll = $new->left->left;
    is($ll->val, undef, 'delete 1');
    is($node->val, 1, 'returned value');
    my $found = $new->find(1);
    is($found, undef, 'finding in the tree');
};

subtest 'right most' => sub {
    plan tests => 3;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->delete(64);
    my $rrr = $new->right->right->right;
    is($rrr->val, undef, 'delete 64');
    is($node->val, 64, 'returned value');
    my $found = $new->find(64);
    is($found, undef, 'finding in the tree');
};

subtest 'just middle' => sub {
    plan tests => 3;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->delete(16);
    is($new->val, 36, 'delete 16');
    is($node->val, 16, 'returned value');
    my $found = $new->find(16);
    is($found, undef, 'finding in the three');
};

#           16
#         /    \
#        4      36
#       / \     / \
#      1   9   25  49
#                    \
#                     64
sub _build_simple_tree {
    my $tree = BinaryTree->new();
    my $node;
    for (1..8) {
        ($tree, $node) = $tree->add($_*$_);
    }
    return $tree;
}

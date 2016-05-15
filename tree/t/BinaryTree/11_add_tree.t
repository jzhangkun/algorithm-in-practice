#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use Test::More tests => 4;
use FindBin qw($Bin);
use lib "$Bin/../..";
use Scalar::Util qw(blessed);
use BinaryTree;

my $tree = BinaryTree->new();

subtest 'add null' => sub {
    plan tests => 2;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->add();
    is_deeply($tree, $new, "same tree");
    is($node, undef, "null node");
};

subtest 'add exist' => sub {
    plan tests => 2;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->add(4);
    is_deeply($tree, $new, 'same tree');
    is($node, undef, "null node");
};

subtest 'add child' => sub {
    plan tests => 2;
    my $tree = _build_simple_tree();
    my ($new, $node) = $tree->add(1);
    my $ll = $new->left->left;
    is_deeply($ll, BinaryTree->new(val => 1), 'left child');
    ($new, $node) = $new->add(3);
    my $lr = $new->left->right;
    is_deeply($lr, BinaryTree->new(val => 3), 'right child');
};

subtest 'add with function' => sub {
    my $tree = _build_simple_tree();
    my $func = sub { $_[1] <=> $_[0] };
    my ($new, $node) = $tree->add(1, $func);
    my $rr = $new->right->right;
    is_deeply($rr, BinaryTree->new(val => 1), 'desc function');
};

exit 0;

sub _build_simple_tree {
    my $tree  = BinaryTree->new(val => 4);
    $tree->left(BinaryTree->new(val => 2));
    $tree->right(BinaryTree->new(val => 6));
    return $tree;
}

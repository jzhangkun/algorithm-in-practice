#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 3;
use FindBin qw($Bin);
use lib "$Bin/../..";
use Scalar::Util qw(blessed);

BEGIN { use_ok('BinaryTree') }


subtest 'new neatly' => sub {
    plan tests => 6;
    my $btree = new_ok('BinaryTree');
    ok(!$btree->has_val, 'no value');
    ok(!$btree->has_left,  'no left node');
    ok(!$btree->has_right, 'no right node');
    is(blessed($btree->left),  'BinaryTree', 'left type');
    is(blessed($btree->right), 'BinaryTree', 'right type');
};


subtest 'new with parameters' => sub {
    plan tests => 9;
    my $btree = new_ok('BinaryTree', [val => 1]);
    ok($btree->has_val, 'has value');
    is($btree->val, 1, 'value');
    ok(!$btree->has_left, 'no left node');
    ok(!$btree->has_right, 'no right node');
    
    $btree->left(BinaryTree->new(val => 2));
    ok($btree->has_left, 'has left node');
    $btree->right(BinaryTree->new(val => 2));
    ok($btree->has_right, 'has right node');

    $btree->clr_left;
    $btree->clr_right;
    ok(!$btree->has_left,  'no left node');
    ok(!$btree->has_right, 'no right node');
};

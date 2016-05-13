#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 4;
use FindBin qw($Bin);
use lib "$Bin/..";
use Scalar::Util qw(blessed);

BEGIN { use_ok('BinaryTree') } 

my $btree = new_ok('BinaryTree');

subtest 'default' => sub {
    plan tests => 9;
    ok(!$btree->has_left,  'no left node');
    ok(!$btree->has_right, 'no right node');
    #is(blessed($btree->left),  'BinaryTree', 'left type');
    #is(blessed($btree->right), 'BinaryTree', 'right type');
    ok($btree->has_left,  'has left node');
    ok($btree->has_right, 'has right node');
    ok(!$btree->has_val, 'has empty value');

    ok($btree->has_left,  'has 2nd left node');
    ok($btree->has_right, 'has 2nd right node');

    $btree->clr_left;
    $btree->clr_right;
    ok(!$btree->has_left,  'no left node');
    ok(!$btree->has_right, 'no right node');
};

$btree->val(1);
ok($btree->has_val, 'has value');


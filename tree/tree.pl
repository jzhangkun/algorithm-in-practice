#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use BinaryTree;

my $tree  = BinaryTree->new();
my $node;
foreach (1..8) {
    ($tree, $node) = $tree->add($_*$_);
}

my ($recorder, $reporter) = aggregator();
$tree->traverse($recorder);
my @results = $reporter->();

for (@results) {
    #print Dumper $_;
    print $_->val, "\n";
}
#print Dumper $tree;

sub aggregator {
    my @list;
    return sub {
        push @list, @_;
    },
    sub { wantarray ? @list : [@list] };
}


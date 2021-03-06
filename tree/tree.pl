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
print "after building tree";
for (@results) {
    print $_->val, "\n";
}

# delete
$tree->delete(4);
($recorder, $reporter) = aggregator();
$tree->traverse($recorder);
@results = $reporter->();
print "after deleting...\n";
for (@results) {
    print $_->val, "\n";
}

sub aggregator {
    my @list;
    return sub {
        push @list, @_;
    },
    sub { wantarray ? @list : [@list] };
}


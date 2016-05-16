#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use lib '.';
use BinaryHeap qw(heapify);

my @heap = qw( toves slithy the and brillig Twas );
print Dumper \@heap;
heapify(\@heap);
print Dumper \@heap;

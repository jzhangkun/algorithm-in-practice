#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use List::Util qw( shuffle );

my @array = shuffle 1..10;

print Dumper \@array;

my @sorted = quick_sort(@array);

print Dumper \@sorted;

sub quick_sort {
    return unless @_;
    my $pivot = shift;
    return ( quick_sort( grep { $_ < $pivot } @_ ),
             $pivot, 
             quick_sort( grep { $_ > $pivot } @_ )
            );
}

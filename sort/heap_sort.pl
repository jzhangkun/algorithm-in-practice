#!/usr/bin/perl -w
use strict;

my @array = qw( 9 12 17 30 50 20 60 65 4 19);
minHeapify(\@array);
print "After heapify:\n";
print "@array\n"; # 4 9 17 12 19 20 60 65 30 50
minHeapSortedDesc(\@array);
print "After heapsorted\n";
print "@array\n";

exit;

sub parent { int( ( $_[0] - 1 ) / 2 ) }
sub left   { int( $_[0] * 2 + 1 ) }
sub right  { int( $_[0] * 2 + 2 ) }

sub minHeapUp {
    my ( $array, $index ) = @_;
    my $iv = $array->[$index];
    
    while ( $index ) {
        my $pi = parent($index);
        my $pv = $array->[$pi];
        last if $pv < $iv;
        $array->[$index] = $pv;
        $index = $pi;
    }
    $array->[$index] = $iv;
    return;
}

sub minHeapDown {
    my ( $array, $index, $last ) = @_;
    
    defined($last) or $last = $#{$array};
    return if $last <= 0;
    
    my $iv = $array->[$index];
    while ( $index < $last ) {
        my $ci = left($index);
        last if $ci > $last;
        my $cv = $array->[$ci]; # The minium child value : left 
                                         # The minium child value : right
        if ( $ci < $last and $array->[$ci+1] < $cv ) { 
            $cv = $array->[$ci+1]; # change to right child value
            ++$ci; # change to right child index
        }
        last if $iv < $cv; # If parent value is less than child value
                                         # Then no need to scan now
        $array->[$index] = $cv; # Or update the replace the parent value of child value
        $index = $ci;
    }
    $array->[$index] = $iv;
    return;
}

sub minHeapify {
    my $array = shift;
    my $last = $#{$array};
    for ( my $i = parent($last); $i >= 0; $i-- ) {
        minHeapDown($array, $i, $last);
    }
    # Using minHeapUp is less efficient than using minHeapDown
    # for ( my $i = 0; $i <= $last; ++$i ) {
        # minHeapUp($array, $i);
    # }
    return;
}

sub minHeapSortedDesc {
    my $array = shift;
    for ( my $i = $#{$array}; $i > 0; ) { # i = 0, no need sort now
        @$array[ 0, $i ] = @$array[ $i, 0 ]; # swap the first(minium) one with the last one
        minHeapDown($array, 0, --$i); # recover the heap and get the minium one in top heap
    }
    return;
}

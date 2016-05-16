package BinaryHeap;
use strict;
use warnings;
use Data::Dumper;
use Exporter;
our @ISA = qw( Exporter );
our @EXPORT_OK = qw(heapup heapdown heapify);

sub heapup {
    my ($ra, $index) = @_;

    my $value = $ra->[$index];
    while ($index) {
        # find its parent to compare
        my $parent = int(($index - 1) / 2);
        my $pv = $ra->[$parent];
        last if $pv lt $value;
        # downgrade parent
        $ra->[$index] = $pv;
        $index = $parent;
    }
    # level up done
    $ra->[$index] = $value;
}

sub heapdown {
    my ($ra, $index, $last) = @_;
    $last = $#{$ra} unless defined $last;

    my $value = $ra->[$index];
    while ($index < $last) {
        # compare with left child
        my $child = 2 * $index + 1;
        last if $child > $last;
        my $cv = $ra->[$child];
        if ($child + 1 < $last) {
            my $cv2 = $ra->[$child + 1];
            if ($cv2 lt $cv) {
                $cv = $cv2;
                ++$child;
            }
        }
        last if $value lt $cv;
        $ra->[$index] = $cv;
        $index = $child;
    }
    $ra->[$index] = $value;
}

sub heapify {
    my ($ra, $last) = @_;
    $last = $#{$ra} unless defined $last;
    for (my $i = int(($last - 1)/2); $i >=0; $i--) {
        heapdown($ra, $i, $last);
    }
}

sub extract_top {
    my ($ra, $last) = @_;
    $last = $#{$ra} unless defined $last;
    # empty array
    return undef if $last < 0;
    # only one in array
    return pop(@$ra) unless $last;
    my $value = $ra->[0];
    $ra->[0] = pop(@$ra);
    heapdown($ra,0);
    return $value;
}

1;

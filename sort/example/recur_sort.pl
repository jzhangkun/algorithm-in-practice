#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my @array = ([1,"a"], [[8,"c"], [6,"d"],[[3,"a"],[1,"c"]]], [2, "b"], [4,"e"]);
#my @array = ([1,'a'], [[4,'d'], [3,'c']], [2, 'b']);
#my @array = ( [ 1, 'a' ], [ [ 4, 'd' ], [ [ 3, 'c' ], [ 5, 'e' ] ] ], [ 2, 'b' ] );

my @sorted = sort { sort_1st($a) <=> sort_1st($b) } @array;

print Dumper \@array;
print Dumper \@sorted;

sub sort_1st {
    my $e = shift;
    if (ref($e->[0]) eq 'ARRAY') {
        @$e = sort { sort_1st($a) <=> sort_1st($b) } @$e;
        #print "e=".Dumper($e) if ref($e->[0][0]) eq 'ARRAY';
        #my $e1 = find_1st($e);
        #print "1st = $e1\n" . 
        #return $e->[0][0];
        #return $e1;
        sort_1st(@$e); #  - replace find_1st
    } else {
        return $e->[0];
    }
}

sub find_1st {
    my $e = shift;
    return ref($e) eq 'ARRAY' 
         ? find_1st($e->[0])
         : $e ;
}


__END__
perl -MData::Dumper -le 'use strict;
my @array = ([1,"a"], [[8,"c"], [6,"d"],[[3,"a"],[1,"c"]]], [2, "b"]);
sub f{my $f=shift; ref($f->[0]) eq "ARRAY" ? f(@$f=sort{f($a)<=>f($b)}@$f) : $f->[0]};
print Dumper [sort {f($a) <=> f($b)}@array]'

#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

# localization
use locale;

use Benchmark qw(:all);
# let's compare the performace
srand; # Randomize.
# NOTE: for Perls < 5.004
# # use srand(time + $$ + ($$ << 15)) for better results

# Generate a nice random input array.
my @array = reverse 'aaa'..'zzz';

# Mutate the @array.

for ( @array ) {
    if (rand() < 0.5) { # Randomly capitalize.
        $_ = ucfirst;
    }
    if (rand() < 0.25) { # Randomly insert underscores.
        substr($_, rand(length), 0)= '_';
    }
    if (rand() < 0.333) { # Randomly double.
        $_ .= $_;
    }
    if (rand() < 0.333) { # Randomly mirror double.
        $_ .= reverse $_;
    }
    if (rand() > 1/length) { # Randomly delete characters.
        substr($_, rand(length), rand(length)) = '';
    }
}

# timethese() comes from Benchmark.
my $timethese = 
timethese(-10, {
    'ST-Cache'  => 
    '@sorted => 
        map { $_->[0] }
       sort { $a->[1] cmp $b->[1] }
        map {
            my $d = lc; # Convert into lowercase.
            $d =~ s/[\W_]+//g; # Remove nonalphanumerics.
            [ $_, $d ] # [original, transformed]
        }
        @array',


    'ST-NewKey' => 
    '@sorted => 
        map { /^\w* (.*)/ }
       sort
        map {
            my $d = lc; # Convert into lowercase.
            $d =~ s/[\W_]+//g; # Remove nonalphanumerics.
            "$d $_" # Concatenate new and original words.
        }
        @array',


    'nonST' =>
    '@sorted =
       sort {
            my ($da, $db) = (lc( $a ), lc( $b ) );
            $da =~ s/[\W_]+//g;
            $db =~ s/[\W_]+//g;
            $da cmp $db;
       }
       @array',
});

cmpthese($timethese);

exit 0;

# Schwartzian Transform
sub forge_cache {
    my $ra = shift;
    my @dictionary_sorted =
        map { $_->[0] }
       sort { $a->[1] cmp $b->[1] }
        map {
            my $d = lc; # Convert into lowercase.
            $d =~ s/[\W_]+//g; # Remove nonalphanumerics.
            [ $_, $d ] # [original, transformed]
        }
        @$ra;
    return \@dictionary_sorted;
}


sub forge_newkey {
    my $ra = shift;
    my @dictionary_sorted =
        map { /^\w* (.*)/ }
       sort
        map {
            my $d = lc; # Convert into lowercase.
            $d =~ s/[\W_]+//g; # Remove nonalphanumerics.
            "$d $_" # Concatenate new and original words.
        }
        @$ra;
    return \@dictionary_sorted;
}

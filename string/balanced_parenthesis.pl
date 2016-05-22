#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

plan tests => 10;
my $str;
$str = '(((33)))';
is(isBalanced($str), 1, $str);

$str = '(((33))))';
is(isBalanced($str), 0, $str);

$str = '((((33)))';
is(isBalanced($str), 0, $str);

$str = '((2+4)3)1(3)';
is(isBalanced($str), 1, $str);

$str = '(2)1)(3)';
is(isBalanced($str), 0, $str);

$str = '(2(4)5(6))1(3)';
is(isBalanced($str), 1, $str);

$str = '9(38';
is(isBalanced($str), 0, $str);

$str = '3902[()]oi';
is(isBalanced($str), 1, $str);

$str = '[(])';
is(isBalanced($str), 0, $str);

$str = '[(1(3)]([[2]])';
is(isBalanced($str), 0, $str);

exit 0;

sub isBalanced {
    my $str = shift;
    my @array = split //, $str;

    my %paired = (
        '(' => ')',
        '[' => ']',
        ')' => '(',
        ']' => '[',
    );
    my ($s, $e);
    my @stack;
    my $is_balance = 1;
    while (@array) {
        $s = shift @array;
        if ($s eq '(' || $s eq '[') {
            push @stack, $s;
            next;
        }
        if ($s eq ')' || $s eq ']') {
            if (!@stack || (pop(@stack) ne $paired{$s})) {
                $is_balance = 0;
                last;
            }
        }
    }
    $is_balance = 0 if @stack;
    return $is_balance;
}


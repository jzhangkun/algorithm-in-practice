package Role::Balanced;
use Moose::Role;
use Data::Dumper;

has 'height' => (
    is  => 'rw',
    isa => 'Num',
    default => 0,
);

# to balance the tree
sub balance {
    my $tree = shift;
    return unless $tree->has_val;
    
    my $lh = $tree->has_left  ? $tree->left->height : 0;
    my $rh = $tree->has_right ? $tree->right->height : 0;

    if ($lh > 1 + $rh) {
        my $return = tree->swing_right;
        return $tree->swing_right;
    }
    elsif ($lh + 1 < $rh) {
        return $tree->swing_left;
    } 
    else {
        $tree->set_height;
        return $tree;
    }
}

sub set_height {
    my $tree = shift;
    my $lh = $tree->has_left  ? $tree->left->height : 0;
    my $rh = $tree->has_right ? $tree->right->height : 0;
    $tree->height($lh < $rh ? $rh + 1 : $lh + 1);
}

# func: $tree->swing_left
#
# change   t        to         r          or    rl
#         / \                 / \             /    \
#        l   r               t   rr          t      r
#           / \             / \             / \    / \
#          rl  rr          l   rl          l rll rlr  rr
#          / \                / \
#        rll rlr            rll rlr
#
sub swing_left {
    my $tree = shift;
    my $r = $tree->right;  # must exist

    my ($rl, $rr);
    $rl = $r->left  if $r->has_left;
    $rr = $r->right if $r->has_right;

    my $rlh = $rl ? $rl->height : 0;
    my $rrh = $rr ? $rr->height : 0;

# change   t        to         t         then       rl
#         / \                 / \                 /    \
#        l   r               l   rl              t      r
#           / \                 /  \            / \    / \
#          rl  rr             rll   r          l  rll rlr rr
#          / \                     /  \
#        rll rlr                  rlr  rr
#

    if ($rlh > $rrh) {
         $tree->right($r->move_right);
    }
    return $tree->move_left;
}

# $tree->swing_right;
sub swing_right {
    my $tree = shift;
    my $l = $tree->left;   # must exist
    my ($ll, $lr);
    $ll = $l->left  if $l->has_left;
    $lr = $l->right if $l->has_right;
    
    my $llh = $ll ? $ll->height : 0;
    my $lrh = $lr ? $lr->height : 0;
    if ($lrh > $llh) {
        $tree->left($l->move_left);
    }
    return $tree->move_right;
}

# $tree->move_left
#
# change    t        to    r
#          / \            / \
#         l   r          t   rr
#            / \        / \
#           rl  rr     l   rl
#
sub move_left {
    my $tree = shift;
    my $r = $tree->right;    # must exist
    if ($r->has_left) {      # might exist
        $tree->right($r->left);
    } else {
        $tree->clr_right;
    }
    $r->left($tree);
    # set height again, low level first
    $tree->set_height;
    $r->set_height;
    return $r;
}

# $tree->move_right
#
# change  t          to    l
#        / \              / \
#       l   r            ll  t
#      / \                  / \
#     ll  lr               lr  r
#
sub move_right {
    my $tree = shift;
    my $l = $tree->left;    # must exist
    if ($l->has_right) {    # might exist
        $tree->left($l->right);
    } else {
        $tree->clr_left;
    }
    $l->right($tree);
    # set height again, low level first
    $tree->set_height;
    $l->set_height;
    return $l;
}

sub bal_add {
    my $tree = shift;
    my $node;
    ($tree, $node) = $tree->add(@_);
    return $tree->balance, $node;
}

sub bal_del {
    my $tree = shift;
}

1;

package Role::Balanced;
use Moose::Role;

has 'height' => (
    is  => 'rw',
    isa => 'Num',
);

# to balance the tree
sub balance {
    my $tree = shift;
    return unless $tree->has_val;
    
    my $lh = $tree->has_left  ? $tree->left->height : 0;
    my $rh = $tree->has_right ? $tree->right->height : 0;
   
    if ($lh > 1 + $rh) {
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
    my $lh = $tree->has_left   ? $tree->height : 0;
    my $rh = $tree->has_lright ? $tree->height : 0;
    $tree->height($lh < $rh ? $rh + 1 : $lh + 1);
}

# 
# change   t        to         r          or    rl
#         / \                 / \             /    \
#        l   r               t   rr          t      r
#           / \             / \             / \    / \
#          rl  rr          l   rl          l rll rlr rrr
#          / \                / \
#        rll rlr            rll rlr
#
sub swing_left {
    my $tree = shift;
    
}

sub swing_right {

}

# 
# change    t        to    r
#          / \            / \
#         l   r          t   rr
#            / \        / \
#           rl  rr     l   rl
#
sub move_left {
    my $tree = shift;
    my $r = $tree->right;
    my $rl = $r->left;
    # redirect
    $tree->right($rl);
    $r->left($tree);
    # set height again, low level first
    $tree->set_height;
    $r->set_height;
    return $r;
}

#
# change  t          to    l
#        / \              / \
#       l   r            ll  t
#      / \                  / \
#     ll  lr               lr  r
#
sub move_right {
    my $tree = shift;
    my $l = $tree->left;
    my $lr = $l->right;
    # redirect
    $tree->left($lr);
    $l->right($tree);
    # set height again, low level first
    $tree->set_height;
    $l->set_height;
}

1;

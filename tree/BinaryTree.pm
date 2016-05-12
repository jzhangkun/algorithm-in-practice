package BinaryTree;
use Moose;

has 'parent' => (
    is  => 'rw',
    isa => 'BinaryTree',
    predicate => 'has_parent',
    weak_ref  => 1,
);

has 'left' => (
    is  => 'rw',
    isa => 'BinaryTree',
    lazy => 1,
    default => sub { BinaryTree->new(parent => $_[0]) },
    predicate => 'has_left',
    clearer   => 'clr_left',
);

has 'right' => (
    is  => 'rw',
    isa => 'BinaryTree',
    lazy => 1,
    default => sub { BinaryTree->new(parent => $_[0]) },
    predicate => 'has_right',
    clearer   => 'clr_right',
);

has 'val' => (
    is  => 'rw',
    isa => 'Any',
    predicate => 'has_val',
);

has 'height' => (
    is  => 'rw',
    isa => 'Num',
);

sub find {
    my $tree = shift;
    my ($val, $cmp) = @_;
    while ($tree->has_val) {
        my $relation = defined $cmp
            ? $cmp->($tree->val, $val)
            : $tree->val <=> $val;
        return $tree if $relation == 0;
        $tree = $relation < 0 ? $tree->left : $tree->right;
    }
    return undef;
}

sub traverse {
    my $tree = shift;
    my $func = shift || sub { print shift->val(), qq{\n} };
    $tree->left->traverse($func)  if $tree->has_left;
    $func->($tree);
    $tree->right->traverse($func) if $tree->has_right;
}

sub add {
    my $tree = shift;
    my ($val, $cmp) = @_;
    my $node;
    if (not $tree->has_val) {
        $node = BinaryTree->new(val => $val);
        return ($node, $node);
    }

    my $relation = defined $cmp
        ? $cmp->($tree->val, $val)
        : $tree->val <=> $val;

    return ($tree, $node) if $relation == 0;

    if ($relation < 0) {
        my $left;
        ($left, $node) = $tree->left->add($val, $cmp); 
        $tree->left($left);
    } else {
        my $right;
        ($right, $node) = $tree->right->add($val, $cmp); 
        $tree->right($right);
    }

    return ($tree->balance(), $node);
}

sub delete {
    my $tree = shift;
    my ($val, $cmp) = @_;
    my $node;

    my $relation = defined $cmp
        ? $cmp->($tree->val, $val)
        : $tree->val <=> $val;

    if ($relation != 0) {
        if ($relation < 0) {
            my $left;
            ($left, $node) = $tree->left->delete($val, $cmp);
            $tree->left($left);
        } else {
            my $right;
            ($right, $node) = $tree->right->delete($val, $cmp);
            $tree->right($right);
        } 
        return ($tree, undef) unless $node;
    } else {
        # delete
        $node = $tree;
        $tree = $tree->join($tree->left, $tree->right);
        $node->clr_left();
        $node->clr_right();
    }

    return ($tree, $node);
}

# to balance the tree
sub balance {
    my $tree = shift;
    
    return $tree;
}

# to join sub trees together
sub join {
    my $tree = shift;

}


1;

package BinaryTree;
use Moose;
use Data::Dumper;

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

with 'Role::Balanced';

before 'right', 'left' => sub {
    my ($tree, $child) = @_;
    # only available for set operation
    $child->parent($tree) if defined $child;
};

sub find {
    my $tree = shift;
    my ($val, $cmp) = @_;
    while ($tree->has_val) {
        my $relation = defined $cmp
            ? $cmp->($val, $tree->val)
            : $val <=> $tree->val;
        return $tree if $relation == 0;
        $tree = $relation < 0 ? $tree->left : $tree->right;
    }
    return undef;
}

sub traverse {
    my $tree = shift;
    my $func = shift || sub { print shift->val(), qq{\n} };
    $tree->left->traverse($func)  if $tree->has_left;
    $func->($tree) if $tree->has_val;
    $tree->right->traverse($func) if $tree->has_right;
}

sub add {
    my $tree = shift;
    my ($val, $cmp) = @_;
    return ($tree, undef) unless $val;
    my $node;
    unless ($tree->has_val) {
        $node = BinaryTree->new(val => $val);
        return ($node, $node);
    }
    my $relation = defined $cmp
        ? $cmp->($val, $tree->val)
        : $val <=> $tree->val;

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

    return ($tree, undef) unless defined $val && $tree->has_val;
    my $relation = defined $cmp
        ? $cmp->($val, $tree->val)
        : $val <=> $tree->val;

    if ($relation != 0) {
        if ($relation < 0) {
            if ($tree->has_left) {
                my $left;
                ($left, $node) = $tree->left->delete($val, $cmp);
                $tree->left($left);
            }
        } else {
            if ($tree->has_right) {
                my $right;
                ($right, $node) = $tree->right->delete($val, $cmp);
                $tree->right($right);
            }
        }
        return ($tree, undef) unless $node;
    } else {
        # delete
        $node = $tree;
        $tree = tree_join($tree->left, $tree->right);
        $node->clr_left();
        $node->clr_right();
    }

    return ($tree, $node);
}

# to join sub trees together
sub tree_join {
    my ($left, $right) = @_;

    return $left unless $left->has_val();
    return $right unless $right->has_val();

    my $top;
    if ($left->height > $right->height) {
        $top = $left;
        $top->right(tree_join($top->right, $right));
    } else {
        $top = $right;
        $top->left(tree_join($left, $top->left));
    }
    return $top->balance;
}


1;

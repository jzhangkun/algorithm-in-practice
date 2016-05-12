package Tree;
use Moose;
use TreeNode;

has 'root' => (
    is  => 'rw',
    isa => 'TreeNode',
);

sub basic_tree_find {
    my $self = shift;
    my ($target, $cmp) = @_;
    
    my $tree_link = \$self->root;
    my $node;
    while ($node = $$tree_link) {
        local $^W = 0;
        my $relation = ((defined $cmp)
                     ? $cmp($target, $node)
                     : $node->val <=> $target->val);

        return $node if $relation == 0;
        # not exactly the same way to go 
        $node = $relation > 0 ? \$node->left : \$node->right;
    }
    return undef;
}

sub basic_tree_add {
    my $self = shift;
    my ($target, $cmp) = @_;
 
    my ($tree_link, $found) = $self->basic_tree_find($target, $cmp);
    unless ($found) {
        $$tree_link = $target;
    }
    return $found;
}

sub basic_tree_del {
    my $self = shift;
    my ($target, $cmp) = @_;
    my ($tree_link, $found) = $self->basic_tree_find($target, $cmp);
    return undef unless $found;

    if ($found->left) {
        
    }
    elsif ($found->right) {

    }
    else {

    }
}

1;

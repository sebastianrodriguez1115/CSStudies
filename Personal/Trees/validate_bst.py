class Node:
  def __init__(self, value=None):
    self.value = value
    self.left = None
    self.right = None

def validate_bst(node, min_val=None, max_val=None):
  if node is None:
    return True

  if min_val is not None and node.value <= min_val:
    return False

  if max_val is not None and node.value >= max_val:
    return False

  return validate_bst(node.left, min_val, node.value) and validate_bst(node.right, node.value, max_val)

tree = Node(8)
tree.left = Node(3)
tree.right = Node(10)
tree.left.left = Node(1)
tree.left.right = Node(6)
tree.left.right.left = Node(4)
tree.left.right.right = Node(7)
tree.right.right = Node(14)
tree.right.right.left = Node(13)
print(validate_bst(tree)) # True

tree = Node(1)
tree.left = Node(3)
tree.right = Node(10)
print(validate_bst(tree)) # False
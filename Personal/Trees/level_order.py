class Node:
  def __init__(self, value=None):
    self.value = value
    self.left = None
    self.right = None

def level_order(root):
  queue = [root]
  while queue:
    node = queue.pop(0)
    print(node.value, end=' ')
    if node.left:
      queue.append(node.left)
    if node.right:
      queue.append(node.right)

tree = Node(8)
tree.left = Node(3)
tree.right = Node(10)
tree.left.left = Node(1)
tree.left.right = Node(6)
tree.right.left = Node(14)
tree.right.right = Node(4)
level_order(tree) 
print()

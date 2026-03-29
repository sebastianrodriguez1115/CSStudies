class Node:
  def __init__(self, value=None):
    self.value = value
    self.left = None
    self.right = None
    self.parent = None

class BST:
  def __init__(self):
    self.root = None

  def insert(self, value):
    if self.root is None:
      self.root = Node(value)
    else:
      self.__insert(self.root, value)
    
  def inorder(self):
    print(self.__inorder(self.root))

  def search(self, value):
    if self.root is None:
      return None

    return self.__search(self.root, value)
  
  def delete(self, value):
    return self.__delete_node(self.root, value)

  def __insert(self, node, value):
    if not node:
      return Node(value)

    if value < node.value:
      node.left = self.__insert(node.left, value)
      node.left.parent = node
    elif value > node.value:
      node.right = self.__insert(node.right, value)
      node.right.parent = node
    
    return node

  def __inorder(self, node):
    if node is not None:
      #print(f"Node: {node.value}, Parent: {node.parent.value if node.parent is not None else None}, Left: {node.left.value if node.left is not None else None}, Right: {node.right.value if node.right is not None else None}")
      l = self.__inorder(node.left)
      r = self.__inorder(node.right)
      return f"{l} {node.value} {r}"
    return ''
 
  def __search(self, node, value):
    if node is None:
      return None

    if node.value == value:
      return node
    
    next_node = node.left if value < node.value else node.right
    return self.__search(next_node, value)

  def __delete_node(self, node, value):
    if node is None:
      return None

    if value < node.value:
      node.left = self.__delete_node(node.left, value)
    elif value > node.value:
      node.right = self.__delete_node(node.right, value)
    else:
      if node.left is None and node.right is None:
        return None
      elif node.left is None:
        node.right.parent = node.parent
        return node.right
      elif node.right is None:
        node.left.parent = node.parent
        return node.left

      successor = self.__subtree_min_value(node.right)
      node.value = successor.value
      node.right = self.__delete_node(node.right, successor.value)

    return node
  
  def __subtree_min_value(self, node):
    current = node
    while current.left is not None:
      current = current.left
    return current

tree = BST()
tree.insert(5)
tree.insert(4)
tree.insert(6)
tree.insert(10)
tree.insert(11)
tree.insert(9)
tree.inorder()
print(tree.search(11).value)
tree.delete(5)
tree.inorder()
tree.delete(6)
tree.inorder()
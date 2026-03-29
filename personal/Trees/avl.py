class Node:
  def __init__(self, value=None):
    self.value = value
    self.left = None
    self.right = None
    self.height = 1

class AVL:
  def __init__(self):
    self.root = None

  def insert(self, value):
    if self.root is None:
      self.root = Node(value)
    else:
      self.root = self.__insert(self.root, value)
    
  def inorder(self):
    print(self.__inorder(self.root))

  def search(self, value):
    if self.root is None:
      return None

    return self.__search(self.root, value)
  
  def delete(self, value):
    self.root = self.__delete_node(self.root, value)
    return self.root
  
  def __insert(self, node, value):
    if not node:
      return Node(value)

    if value < node.value:
      node.left = self.__insert(node.left, value)
    elif value > node.value:
      node.right = self.__insert(node.right, value)
    
    node.height = self.__height(node)

    bf = self.__balance_factor(node)
    # This conditionals will balance the tree when they are 1 recursion up of the insertion because of the strict inequality
    if bf > 1 and value < node.left.value:
      # When:
      #   parent
      #    /
      #  node
      #  /
      # new
      return self.__right_rotate(node)
    elif bf < -1 and value > node.right.value:
      # When:
      #   parent
      #      \
      #      node
      #         \
      #         new
      return self.__left_rotate(node)
    elif bf > 1 and value > node.left.value:
      # When:
      #   parent
      #    /
      #  node
      #    \
      #    new
      node.left = self.__left_rotate(node.left)
      return self.__right_rotate(node)
    elif bf < -1 and value < node.right.value:
      # When:
      #   parent
      #      \
      #      node
      #      /
      #     new
      node.right = self.__right_rotate(node.right)
      return self.__left_rotate(node)
    
    return node

  def __balance_factor(self, node):
    # The balance factor is the difference between the height of the left subtree and the right subtree.
    #   - A negative value means that the right subtree is taller.
    #   - A positive value means that the left subtree is taller.
    if node is None:
      return 0

    return self.__height(node.left) - self.__height(node.right)
  
  def __inorder(self, node):
    if node is not None:
      print(f"Node: {node.value}, Left: {node.left.value if node.left is not None else None}, Right: {node.right.value if node.right is not None else None}")
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
        return node.right
      elif node.right is None:
        return node.left

      # Get the inorder successor
      successor = self.__subtree_min_value(node.right)
      node.value = successor.value
      node.right = self.__delete_node(node.right, successor.value)

    bf = self.__balance_factor(node)

    if bf > 1 and self.__balance_factor(node.left) >= 0:
      return self.__right_rotate(node)
    elif bf < -1 and self.__balance_factor(node.right) <= 0:
      return self.__left_rotate(node)
    elif bf > 1 and self.__balance_factor(node.left) < 0:
      node.left = self.__left_rotate(node.left)
      return self.__right_rotate(node)
    elif bf < -1 and self.__balance_factor(node.right) > 0:
      node.right = self.__right_rotate(node.right)
      return self.__left_rotate(node)

    return node
  
  def __subtree_min_value(self, node):
    current = node
    while current.left is not None:
      current = current.left
    return current

  def __height(self, node):
    if node is None:
      return 0

    return 1 + max(self.__height(node.left), self.__height(node.right))
  
  def __left_rotate(self, A):
    # Given:          Do:
    #    A               B
    #   / \             / \
    #  X   B           A   Z
    #     / \         / \ 
    #    Y   Z       X   Y 
    B = A.right
    Y = B.left

    B.left = A
    A.right = Y

    A.height = self.__height(A)
    B.height = self.__height(B)

    return B

  def __right_rotate(self, B):
    # Given:          Do:
    #      B               A
    #     / \             / \
    #    A   Z           X   B
    #   / \                 / \
    #  X   Y               Y   Z
    A = B.left
    Y = A.right
    
    A.right = B
    B.left = Y
    
    B.height = self.__height(B)
    A.height = self.__height(A)
    
    return A

tree = AVL()
tree.insert(56)
tree.insert(45)
tree.insert(30)
tree.insert(50)
tree.insert(35)
tree.insert(90)
tree.insert(70)
tree.insert(65)
tree.insert(75)
tree.insert(95)
tree.insert(99)
tree.inorder()
tree.delete(30)
tree.delete(35)
tree.inorder()
print(tree.search(31))

  
#
# Binary trees are already defined with this interface:
# class Tree(object):
#   def __init__(self, x):
#     self.value = x
#     self.left = None
#     self.right = None
def solution(tree):
  if tree is None:
    return True

  string_left = traverse(tree.left, '')
  string_right = traverse_inverted(tree.right, '')
  return string_left == string_right

def traverse(tree, string):
    if tree is None:
        return string

    string += str(tree.value)
    string = traverse(tree.left, f"{string}l")
    string = traverse(tree.right, f"{string}r")

    return string

def traverse_inverted(tree, string):
    if tree is None:
        return string

    string += str(tree.value)
    string = traverse_inverted(tree.right, f"{string}l")
    string = traverse_inverted(tree.left, f"{string}r")

    return string

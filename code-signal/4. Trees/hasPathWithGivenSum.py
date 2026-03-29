#
# Binary trees are already defined with this interface:
# class Tree(object):
#   def __init__(self, x):
#     self.value = x
#     self.left = None
#     self.right = None
def solution(tree, sum):
  if tree is None:
    return False
  sums = traverse(tree, 0, [])
  return sum in sums

def traverse(tree, sum, sums):
    if tree is None:
        return
    if tree.left is None and tree.right is None:
        sums.append(sum + tree.value)
        return sums
    traverse(tree.left, sum + tree.value, sums)
    traverse(tree.right, sum + tree.value, sums)
    return sums
    

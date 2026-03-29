# Binary trees are already defined with this interface:
# class Tree(object):
#   def __init__(self, x):
#     self.value = x
#     self.left = None
#     self.right = None
def solution(t, k):
    values = []
    traverse(t, values)
    values.sort()
    return values[k-1]

def traverse(node, values):
    if node is None:
        return
    values.append(node.value)
    traverse(node.left, values)
    traverse(node.right, values)

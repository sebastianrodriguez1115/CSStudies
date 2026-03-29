# Binary trees are already defined with this interface:
# class Tree(object):
#   def __init__(self, x):
#     self.value = x
#     self.left = None
#     self.right = None
def solution(t1, t2):
    return traverse(t2) in traverse(t1)

def traverse(node):
    if node is None:
        return 'n'

    left_string = traverse(node.left)
    right_string = traverse(node.right)
    
    return str(node.value) + f"l{left_string}" + f"r{right_string}"
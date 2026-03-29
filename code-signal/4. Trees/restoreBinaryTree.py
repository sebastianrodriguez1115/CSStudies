# Binary trees are already defined with this interface:
class Tree(object):
  def __init__(self, x):
    self.value = x
    self.left = None
    self.right = None

def solution(inorder, preorder):
    return build_tree(inorder, preorder)    

def build_tree(inorder, preorder):
    node_value = preorder.pop(0)
    node = Tree(node_value)
    inorder_index = inorder.index(node_value)
    
    left_nodes = inorder[0:inorder_index]
    right_nodes = inorder[inorder_index+1:]
    
    if not left_nodes and not right_nodes:
        return node
    
    node.left = build_tree(left_nodes, preorder) if left_nodes else None
    node.right = build_tree(right_nodes, preorder) if right_nodes else None
    
    return node
    

def solution(t, queries):
  for query in queries:
    t = delete(t, query)
  return t

def rightmost_parent(node):
  node_parent = None
  while node.right is not None:
    node_parent = node
    node = node.right
  return node_parent


def delete(node, value):
  if node is None:
    return None

  if node.value < value:
    node.right = delete(node.right, value)
    return node
  elif node.value > value:
    node.left = delete(node.left, value)
    return node

  if node.left:
    if node.left.right:
        rightmost_node_parent = rightmost_parent(node.left)
        rightmost_node = rightmost_node_parent.right
        node.value = rightmost_node.value
        rightmost_node_parent.right = rightmost_node.left
    else:
        node.left.right = node.right
        node = node.left

  else:
    node = node.right

  return node
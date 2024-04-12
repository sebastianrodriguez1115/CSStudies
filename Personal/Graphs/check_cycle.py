class Node:
  def __init__(self, value=None):
    self.value = value
    self.edges = []

  def add_edge(self, node):
    self.edges.append(node)

def check_cycle(graph):
  if graph is None:
    return False

  visited = set()

  return dfs(graph, graph, visited)

def dfs(node, parent, visited):
  if (parent.value, node.value) in visited:
    return True
  
  visited.add((parent.value, node.value))
  for next in node.edges:
    # We need to clone the set to get the visited ONLY for this path
    if dfs(next, node, visited.copy()):
      return True

  return False  

print("++++++++++++++++++++++++++")
g = Node(0)
g1 = Node(1)
g2 = Node(2)
g3 = Node(3)
g4 = Node(4)

g.add_edge(g1)
g1.add_edge(g2)
g2.add_edge(g3)
g3.add_edge(g4)
g4.add_edge(g)

print(check_cycle(g))
# print("++++++++++++++++++++++++++")
# g = Node(0)
# g1 = Node(1)
# g2 = Node(2)
# g3 = Node(3)

# g.add_edge(g1)
# g.add_edge(g2)
# g.add_edge(g3)
# g1.add_edge(g2)
# g1.add_edge(g3)
# g2.add_edge(g3)

# print(list(map(lambda x: x.value, g.edges)))
# print(list(map(lambda x: x.value, g1.edges)))
# print(list(map(lambda x: x.value, g2.edges)))
# print(list(map(lambda x: x.value, g3.edges)))

# print(check_cycle(g))
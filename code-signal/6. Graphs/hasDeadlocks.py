def solution(connections):
  if not connections:
    return False

  for i in range(len(connections)):
    visited = set()

    if dfs(connections, i, i, visited):
      return True

  return False

def dfs(connections, node_value, parent_value, visited):
  print(f"node_value: {node_value}, parent_value: {parent_value}, visited: {visited}")
  if (parent_value, node_value) in visited:
    return True
  
  visited.add((parent_value, node_value))
  print(f"Connections: {connections[node_value]}")
  for next in connections[node_value]:
    # We need to clone the set to get the visited ONLY for this path
    if dfs(connections, next, node_value, visited.copy()):
      return True

  return False

print(solution([[1], [2], [3, 4], [4], [0]]))
print(solution([[1, 2, 3], [2, 3], [3], []]))
print(solution([[1,2], [2], [], [4], [3]]))

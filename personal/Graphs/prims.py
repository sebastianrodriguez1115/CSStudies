import heapq

# Gets the MST (minimum spanning tree) of a graph using Prim's algorithm
def prims(graph, start):
  visited = set([start])
  unvisited = set(graph.keys()) - visited
  total_cost = 0
  MST = []

  # Will keep nodes in a priority queue to always pick the smallest edge
  priority_queue = graph[start]
  heapq.heapify(priority_queue)

  while unvisited:
    cost, destination, source = heapq.heappop(priority_queue)
    new_node = None

    # Only two options either the source is in visited or the destination is in visited,
    # we can't have both in visited because that would create a cycle, and we can't have both in unvisited cuz duh.
    if source in visited and destination in unvisited:
      new_node = destination
      MST.append((source, destination, cost))
    elif source in unvisited and destination in visited:
      new_node = source
      MST.append((destination, source, cost))

    if new_node:
      unvisited.remove(new_node)
      visited.add(new_node)
      total_cost += cost

      for node in graph[new_node]:
        heapq.heappush(priority_queue, node)
  
  return MST, total_cost

# Tuples will have the cost first to make the priority queue work
g = {
  'A': [(3, 'D', 'A'), (3, 'C', 'A'), (2, 'B', 'A')],
  'B': [(2, 'A', 'B'), (4, 'C', 'B'), (3, 'E', 'B')],
  'C': [(3, 'A', 'C'), (5, 'D', 'C'), (6, 'F', 'C'), (1, 'E', 'C'), (4, 'B', 'C')],
  'D': [(3, 'A', 'D'), (5, 'C', 'D'), (7, 'F', 'D')],
  'E': [(8, 'F', 'E'), (1, 'C', 'E'), (3, 'B', 'E')],
  'F': [(9, 'G', 'F'), (8, 'E', 'F'), (6, 'C', 'F'), (7, 'D', 'F')],
  'G': [(9, 'F', 'G')],
}

print(prims(g, 'A'))
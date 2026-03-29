def solution(skyMap):
  if not skyMap:
    return 0
  
  rows = len(skyMap)
  cols = len(skyMap[0])
  visited = [[False for _ in range(cols)] for _ in range(rows)]
  count = 0
  for i in range(rows):
    for j in range(cols):
      if visited[i][j] or skyMap[i][j] == '0':
        continue

      mark_cloud(skyMap, visited, i, j)
      count += 1

  return count

def mark_cloud(skyMap, visited, i, j):
  if i < 0 or i >= len(skyMap) or j < 0 or j >= len(skyMap[0]) or visited[i][j] or skyMap[i][j] == '0':
    return
  
  visited[i][j] = True
  mark_cloud(skyMap, visited, i - 1, j)
  mark_cloud(skyMap, visited, i + 1, j)
  mark_cloud(skyMap, visited, i, j - 1)
  mark_cloud(skyMap, visited, i, j + 1)

  return


sm = [
  ['0', '1', '1', '0', '1'],
  ['0', '1', '1', '1', '1'],
  ['0', '0', '0', '0', '1'],
  ['1', '0', '0', '1', '1']
]

# sm = [
#   ['0', '1', '0', '0', '1'],
#   ['1', '1', '0', '0', '0'],
#   ['0', '0', '1', '0', '1'],
#   ['0', '0', '1', '1', '0'],
#   ['1', '0', '1', '1', '0']
# ]
print(solution(sm))
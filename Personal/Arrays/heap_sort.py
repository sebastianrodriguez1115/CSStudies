import heapq

def heap_sort(array):
  heapq.heapify(array)
  return [heapq.heappop(array) for _ in range(len(array))]

print(heap_sort([5, 4, 3, 2, 1])) # [1, 2, 3, 4, 5]
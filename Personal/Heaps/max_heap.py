class MaxHeap:
  def __init__(self):
    self.heap = []

  def left_child_index(self, index):
    return 2 * index
  
  def right_child_index(self, index):
    return 2 * index + 1
  
  def parent_index(self, index):
    return index // 2
  
  def max_heapify(self, index):
    left_index = self.left_child_index(index)
    right_index = self.right_child_index(index)
    
    largest = index
    if left_index < len(self.heap) and self.heap[left_index] > self.heap[largest]:
      largest = left_index

    if right_index < len(self.heap) and self.heap[right_index] > self.heap[largest]:
      largest = right_index

    if largest != index:
      self.heap[index], self.heap[largest] = self.heap[largest], self.heap[index]
      self.max_heapify(largest)

  def build_max_heap(self, array):
    self.heap = array
    for index in range(len(array) // 2, -1, -1):
      self.max_heapify(index)

max_heap = MaxHeap()
max_heap.build_max_heap([5, 4, 3, 2, 1])
print(max_heap.heap) # [5, 4, 2, 1, 3]
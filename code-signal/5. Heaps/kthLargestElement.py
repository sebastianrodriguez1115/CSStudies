def parent_index(i):
  return (i - 1) // 2

def left_child_index(i):
  return 2 * i + 1

def right_child_index(i):
  return 2 * i + 2

def has_parent(i):
  return parent_index(i) >= 0

def has_left_child(i, heap):
  return left_child_index(i) < len(heap)

def has_right_child(i, heap):
  return right_child_index(i) < len(heap)

def parent(i, heap):
  return heap[parent_index(i)]

def left_child(i, heap):
  return heap[left_child_index(i)]

def right_child(i, heap):
  return heap[right_child_index(i)]

def swap(i, j, heap):
  heap[i], heap[j] = heap[j], heap[i]

def heapify_down(i, heap):
  biggest = i
  if has_left_child(i, heap) and left_child(i, heap) >= heap[biggest]:
    biggest = left_child_index(i)
  if has_right_child(i, heap) and right_child(i, heap) >= heap[biggest]:
    biggest = right_child_index(i)
  if i != biggest:
    swap(i, biggest, heap)
    heapify_down(biggest, heap)

def remove_min(heap):
  if len(heap) == 0:
    return None

  heap[0] = heap[-1]
  heap.pop()
  heapify_down(0, heap)

def solution(nums, k):
  for i in range(len(nums) // 2, -1, -1):
    heapify_down(i, nums)
  print(nums)
  answer = 0
  for _ in range(k):
    answer = nums[0]
    remove_min(nums)
  return answer

nums = [7,6,5,4,3,2,1]
k = 2
print(solution(nums, k))
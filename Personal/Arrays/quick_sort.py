def quick_sort(array, left, right):
  if left < right:
    partition_position = partition(array, left, right)
    quick_sort(array, left, partition_position - 1)
    quick_sort(array, partition_position + 1, right)

  return array

def partition(array, left, right):
  i = left
  j = right - 1
  pivot = array[right]

  while i < j:
    while array[i] < pivot and i < right:
      i += 1
    while array[j] > pivot and j > left:
      j -= 1

    if i < j:
      array[i], array[j] = array[j], array[i]
  
  if array[i] > pivot:
    array[i], array[right] = array[right], array[i]

  return i

a = [5, 4, 3, 2, 1]
print(quick_sort(a, 0, len(a) - 1))
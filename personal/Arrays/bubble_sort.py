def bubble_sort(array):
  for _ in range(len(array)):
    for j in range(len(array) - 1):
      if array[j] > array[j + 1]:
        array[j], array[j + 1] = array[j + 1], array[j]
  return array

print(bubble_sort([3, 1, 2, 5, 4])) # [1, 2, 3, 4, 5]
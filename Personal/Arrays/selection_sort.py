def selection_sort(array):
  for i in range(len(array)):
    min_index = i
    for j in range(i + 1, len(array)):
      if array[j] < array[min_index]:
        min_index = j
    array[i], array[min_index] = array[min_index], array[i]

  return array

print(selection_sort([3, 1, 2, 5, 4])) # [1, 2, 3, 4, 5]
def solution(nums, k):
  nums_indexes = get_indexes(nums)
  repeated_indexes = list(filter(lambda indexes: len(indexes) > 1, nums_indexes.values()))
  for indexes in repeated_indexes:
    for i in range(len(indexes)):
      for j in range(i + 1, len(indexes)):
        if abs(indexes[i] - indexes[j]) <= k:
          return True
  return False

def get_indexes(array):
  indexes = {}
  index = 0
  for value in array:
    if value in indexes:
      indexes[value].append(index)
    else:
      indexes[value] = [index]
    index += 1
  return indexes

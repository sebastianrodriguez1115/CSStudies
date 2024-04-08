def solution(strings, patterns):
  strings_indexes = get_indexes(strings)
  patterns_indexes = get_indexes(patterns)
  return list(strings_indexes.values()) == list(patterns_indexes.values())

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
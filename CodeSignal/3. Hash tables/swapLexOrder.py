def solution(string, pairs):
  # Using sets to be able to join and intersect
  setted_pairs = list(map(set, pairs))
  # First char is empty to make the index match the number
  lst = [''] + list(string)
  # Loop the setted pairs
  while setted_pairs:
    # Remove the the last element from the setted pairs to start calculating the path
    path = setted_pairs.pop(0)
    while True:
      path1 = path.copy()
      # For each pair, if the path intersects with the pair, the path is updated
      for pair in setted_pairs:
        # If the path intersects with the pair, the path is updated
        if path1 & pair:
          path |= pair
          # The pair is removed from the setted pairs
          setted_pairs.remove(pair)
      if path == path1:
        break
    # Sort the elements, because we can move the elements in the path to the optimal position
    optimal = sorted(lst[i] for i in path)
    # Update the list with the optimal values
    for i, v in enumerate(sorted(path, reverse=True)):
        # The sorting is bigger first, so we need to reverse the path
        lst[v] = optimal[i]
  return ''.join(lst[1:])

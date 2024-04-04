def solution(coins, quantity):
  possible_sums = {0}
  for coin, count in zip(coins, quantity):
    new_sums = []
    for x in possible_sums:
      for i in range(count + 1):
        new_sums.append(x + coin * i)
    possible_sums.update(new_sums)
  
  return len(possible_sums) - 1

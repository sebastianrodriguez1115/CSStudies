def solution(level, pos):
  if level == 1:
    return "Engineer"

  leaves_count = (2 ** (level - 1))
  current_profesion = 'E'
  current_position = 0
  for i in range(1, level):
    if pos > current_position + leaves_count / (2**i):
      current_position += leaves_count / (2**i)
      current_profesion = "D" if current_profesion == "E" else "E"
    else:
      current_profesion = "E" if current_profesion == "E" else "D"

  return "Doctor" if current_profesion == "D" else "Engineer"

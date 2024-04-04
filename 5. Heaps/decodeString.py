def solution(string):
  result = ""
  times_stack = []
  patterns_stack = []
  current_pattern = ""
  index = 0
  while index < len(string):
    char = string[index]

    if char.isdigit():
      digits = char
      while string[index + 1].isdigit():
        index += 1
        digits += string[index]
      times_stack.append(int(digits))
      patterns_stack.append(current_pattern)
    elif char == "[":
      next_char = string[index + 1]
      if next_char == "[" or next_char.isdigit():
        current_pattern = ""
      else:
        current_pattern = next_char
        index += 1
    elif char == "]":
      times = times_stack.pop()
      old_pattern = patterns_stack.pop()
      if len(patterns_stack) > 0:
        old_pattern += current_pattern * times
      else:
        result += current_pattern * times
      current_pattern = old_pattern
    elif current_pattern:
      current_pattern += char
    else:
      result += char
    index += 1

  return result

s = "100[codesignal]"
print(solution(s))
s = "2[2[b]]"
print(solution(s))
s = "2[b3[a]]"
print(solution(s))
s = "z1[y]zzz2[abc]"
print(solution(s))
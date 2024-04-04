def solution(a):
  stack = []
  answer = []
  for index in range(len(a) - 1, -1, -1):
    value = a[index]
    while stack and stack[-1] < value:
      stack.pop()
    
    answer = [stack[-1] if stack else -1] + answer
    stack.append(value)
  return answer

a = [6, 7, 3, 8]
print(solution(a))
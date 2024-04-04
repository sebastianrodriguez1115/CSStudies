class ProxyStack:
  def __init__(self):
    self.stack = []
    self.results = []
    
  def execute(self, value):
    operation = value.split(' ')
    action = operation[0]
    if action == 'push':
      self.stack.append(int(operation[1]))
    elif action == 'pop':
      self.stack.pop()
    elif action == 'min':
      self.results.append(min(self.stack))
  
  def min(self):
    return min(self.stack)
  
def solution(operations):
  stack = ProxyStack()
  for operation in operations:
    stack.execute(operation)
  return stack.results


ops = ["push 10", "min", "push 5", "min", "push 8", "min", "pop", "min", "pop", "min"]
print(solution(ops))
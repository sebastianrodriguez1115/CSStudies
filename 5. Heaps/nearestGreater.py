def solution(array):
  result = [-1] * len(array) # initialize result array with -1's
  stack = [0] # initialize stack with the first element of the array
  for i in range(1, len(array)): # iterate through the array starting from the second element
    current_element = array[i]
    # while:
    #   - Stack is not empty 
    #   - if the current element is greater than the stack head value then stop
    # or also can be understood as if current element is still less than the last element of the stack, then we need to keep searching for the next greater element,
    # and all the elements in the stack will have the same next greater element found which will be set in the inner if. So continue the outer loop and append to the stack
    while stack and array[stack[-1]] < current_element:
      j = stack.pop() # pop the last element of the stack
      # result[j] == -1: It's when the current element is greater than the last element of the stack
      # i - j < j - result[j]: Ensures picking the closest value to the current element 
      if result[j] == -1 or i - j < j - result[j]: 
        result[j] = i # If both conditions are met, set the result at the last element of the stack to the current element
    
    if stack: # if the stack is not empty set result[i], otherwise leave it as -1
      # if the current element is not equal to the last element of the stack, set the result at the current element to the last element of the stack
      if current_element != array[stack[-1]]:
        result[i] = stack[-1] 
      # otherwise, set the result at the current element to the result at the last element of the stack, because the current element is equal to the last element of the stack
      else:
        result[i] = result[stack[-1]]    

    stack.append(i) # append the current element to the stack

  return result

arr = [1, 4, 2, 1, 7, 6]
print(solution(arr))
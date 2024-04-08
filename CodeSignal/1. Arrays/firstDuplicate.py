# Given an array a that contains only numbers in the range from 1 to a.length, find the first duplicate 
# number for which the second occurrence has the minimal index. In other words, if there are more than 1 
# duplicated numbers, return the number for which the second occurrence has a smaller index than the second 
# occurrence of the other number does. If there are no such elements, return -1.
def solution(a):
    unique = set(a)    
    counts = {v: 0 for v in unique}
    for value in a:
        counts[value] += 1
        if counts[value] == 2:
            return value
    return -1

a = [2, 1, 3, 5, 3, 2]
print(solution(a) == 3)

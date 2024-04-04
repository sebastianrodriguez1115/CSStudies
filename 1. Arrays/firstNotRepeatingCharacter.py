# Given a string s consisting of small English letters, find and return 
# the first instance of a non-repeating character in it. If there is no such character, return '_'.
def solution(s):
    unique = set(s)
    counts = {v: 0 for v in unique}
    indexes = {v: -1 for v in unique}
    index = 0
    for value in s:
        counts[value] += 1
        if value in indexes:
            if counts[value] >= 2:
                indexes.pop(value)
            else:
                indexes[value] = index
        index += 1
    singles = list(indexes.values())
    return s[min(singles)] if singles else '_'
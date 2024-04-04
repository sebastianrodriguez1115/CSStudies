class Node:
  def __init__(self, value):
    self.left = None
    self.right = None
    self.value = value

def solution(words, parts):
  answer = []
  parts.sort()
  max_part_len = 5
  bst = parts_bst(parts)
  for word in words:
    word_len = len(word)
    new_word = word
    for length in range(max_part_len + 1, 0, -1):
      for char_index in range(word_len - length + 1):
        if search_bst(bst, word[char_index:char_index + length]):
          new_word = f"{word[:char_index]}[{word[char_index:char_index + length]}]{word[char_index + length:]}"
          break
      if new_word != word:
        break
    answer.append(new_word)

  return answer

def parts_bst(parts):
  if len(parts) == 0:
    return None

  mid = len(parts) // 2
  root = Node(parts[mid])
  root.left = parts_bst(parts[:mid])
  root.right = parts_bst(parts[mid + 1:])

  return root

def search_bst(bst, word):
  if bst is None:
    return False

  if bst.value == word:
    return True
  elif bst.value < word:
    return search_bst(bst.right, word)
  elif bst.value > word:
    return search_bst(bst.left, word)
  else:
    return False
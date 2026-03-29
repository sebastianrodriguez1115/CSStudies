# Singly-linked lists are already defined with this interface:
# class ListNode(object):
#   def __init__(self, x):
#     self.value = x
#     self.next = None
#

def move_head(l, k):
  while l and l.value == k:
      l = l.next
  return l

def discard_ks(l, k):
  if not l:
    return l

  previous_node = l
  current_node = l.next
  while current_node.next is not None:
    if current_node.value == k:
      previous_node.next = current_node.next
    else:
      previous_node = current_node
    current_node = current_node.next

  if current_node.value == k:
    previous_node.next = None

  return l

def solution(l, k):
  l = move_head(l, k)
  l = discard_ks(l, k)

  return l
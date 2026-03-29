# Singly-linked lists are already defined with this interface:
# class ListNode(object):
#   def __init__(self, x):
#     self.value = x
#     self.next = None
#
def solution(l1, l2):
  if not l1 and not l2:
    return None
  if not l1:
    return l2
  if not l2:
    return l1

  l3 = None
  if l1 and l1.value < l2.value:
    l3 = l1
    l1 = l1.next
  else:
    l3 = l2
    l2 = l2.next

  returned_l3 = l3

  while l1 or l2:
      if (l1 and l2 and l1.value < l2.value) or not l2:
        l3.next = l1
        l1 = l1.next
      else:
        l3.next = l2
        l2 = l2.next
      l3 = l3.next

  return returned_l3
            

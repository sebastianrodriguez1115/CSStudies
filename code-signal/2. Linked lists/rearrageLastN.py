# Singly-linked lists are already defined with this interface:
# class ListNode(object):
#   def __init__(self, x):
#     self.value = x
#     self.next = None
#
def solution(l, n):
    if l is None:
        return None

    node = l
    new_head_parent = None
    tail = None
    count = 0
    while node:
        if count < n:
            count += 1
        elif new_head_parent is None:
            new_head_parent = l
            tail = node
        else:
            new_head_parent = new_head_parent.next
            tail = node
        node = node.next
    
    if new_head_parent == None:
        return l

    tail.next = l
    l = new_head_parent.next
    new_head_parent.next = None

    return l

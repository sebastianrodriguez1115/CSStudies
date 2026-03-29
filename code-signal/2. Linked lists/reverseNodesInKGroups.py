# Singly-linked lists are already defined with this interface:
# class ListNode(object):
#   def __init__(self, x):
#     self.value = x
#     self.next = None
#
def solution(l, k):
    if k == 1:
        return l

    node = l
    head = None
    previous_tail = None
    while node and node.next:
        if not can_reverse(node, k):
            break
        new_head, new_start = reverse(node, node.next, k, 1)
        node.next = new_start

        if previous_tail:
            previous_tail.next = new_head
        if head is None:
            head = new_head

        previous_tail = node
        node = new_start

    return head

def reverse(previous_node, node, k, iteration):
    if k <= iteration:
        return (previous_node, node)
    elif node.next is None:
        node.next = previous_node
        return (node, None)
    else:
        new_head, new_start = reverse(node, node.next, k, iteration + 1)
        node.next = previous_node
        return (new_head, new_start)

def can_reverse(head, k):
    if head is None:
        return True

    count = 0
    node = head
    while node:
        count += 1
        if count == k:
            return True
        node = node.next
    return False
        
    
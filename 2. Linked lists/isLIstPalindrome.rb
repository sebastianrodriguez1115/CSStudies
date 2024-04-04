# Definition for singly-linked list:
# class ListNode
#   attr_accessor :value, :next
#   def initialize(val)
#     @value = val
#     @next = nil
# end
#
def solution(l)
  return true unless l
  return true if l.next.nil?
  inverted_list = invert_list(l)
  array = list_to_a(l)
  inverted_array = list_to_a(inverted_list)
  array == inverted_array
end

def invert_list(head)
  previous = clone_node(head)
  current = clone_node(head.next)
  previous.next = nil
  new_head = nil
  loop do
    next_node = clone_node(current.next)
    current.next = previous

    if next_node
      previous = clone_node(current)
      current = clone_node(next_node)
    else
      new_head = current
      break
    end
  end

  new_head
end

def clone_node(node)
  return nil unless node
  new_node = ListNode.new(node.value)
  new_node.next = node.next
  new_node
end

def list_to_a(head)
  array = []
  current = head
  loop do
    array.push(current.value)
    break unless current.next
    current = current.next
  end
  array
end

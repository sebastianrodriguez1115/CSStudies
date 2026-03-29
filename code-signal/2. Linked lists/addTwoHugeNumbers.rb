# Definition for singly-linked list:
# class ListNode
#   attr_accessor :value, :next
#   def initialize(val)
#     @value = val
#     @next = nil
# end
#
def self.solution(a, b)
  add_nodes(invert_list(a), invert_list(b))
end

# @param [ListNode] a
# @param [ListNode] b
# @return [Hash]
def self.add_nodes(a, b)
  sum = []
  remainder = 0
  loop do
    if a.nil? && b.nil?
      sum.unshift(remainder) if remainder > 0
      break
    end
    value_a = node_value(a)
    value_b = node_value(b)

    big_number = value_a + value_b + remainder
    remainder = (big_number / 10_000).floor
    four_digit_result = big_number - (remainder * 10_000)
    sum.unshift(four_digit_result)

    a = tail(a)
    b = tail(b)
  end
  sum
end

# @param [ListNode] node
def self.node_value(node)
  if node.nil?
    0
  else
    node.value
  end
end

def self.tail(node)
  node.next if node
end

def self.invert_list(head)
  return head if head.nil? || head.next.nil?
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

def self.clone_node(node)
  return nil unless node
  new_node = ListNode.new(node.value)
  new_node.next = node.next

  new_node
end

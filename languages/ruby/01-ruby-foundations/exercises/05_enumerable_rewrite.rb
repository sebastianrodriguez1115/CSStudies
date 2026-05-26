# frozen_string_literal: true

# Objetivo: reescribir loops manuales usando Enumerable.

numbers = [1, 2, 3, 4, 5]

def double_numbers(numbers)
  numbers.map { |number| number * 2 }
end

def even_numbers(numbers)
  numbers.select(&:even?)
end

def sum_numbers(numbers)
  numbers.reduce(:+)
end

p double_numbers(numbers)
p even_numbers(numbers)
p sum_numbers(numbers)

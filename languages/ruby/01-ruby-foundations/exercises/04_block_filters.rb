# frozen_string_literal: true

# Objetivo: filtrar datos usando un bloque recibido por el metodo.
# Ejemplo: filter_numbers([1, 2, 3]) { |number| number.odd? } -> [1, 3]

numbers = [1, 2, 3, 4, 5, 6]

def filter_numbers(numbers)
  filtered = []

  numbers.each do |number|
    filtered << number if yield(number)
  end

  filtered
end

puts filter_numbers(numbers) { |number| number.odd? }
puts filter_numbers(numbers) { |number| number > 3 }

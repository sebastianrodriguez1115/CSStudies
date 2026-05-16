# frozen_string_literal: true

# Objetivo: agrupar transacciones por categoria.
# Ejemplo: [{ category: 'food', amount: 10 }] -> { 'food' => [...] }

transactions = [
  { category: 'food', amount: 12 },
  { category: 'books', amount: 20 },
  { category: 'food', amount: 8 },
  { category: 'transport', amount: 5 },
  { category: 'books', amount: 15 }
]

def group_by_category(transactions)
  transactions.group_by { |transaction| transaction[:category] }
end

puts group_by_category(transactions)

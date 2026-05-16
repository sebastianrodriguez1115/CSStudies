# frozen_string_literal: true

# Objetivo inicial: calcular el total general de gastos.

expenses = [
  { category: 'food', amount: 12.50 },
  { category: 'books', amount: 20.00 },
  { category: 'food', amount: 7.25 },
  { category: 'transport', amount: 5.00 }
]

def total_amount(expenses)
  expenses.reduce(0) { |sum, expense| sum + expense[:amount] }
end

def totals_by_category(expenses)
  grouped = expenses.group_by { |expense| expense[:category] }
  grouped.transform_values { |category| category.reduce(0) { |sum, expense| sum + expense[:amount] } }
end

def largest_expense(expenses)
  expenses.max { |a, b| a[:amount] <=> b[:amount] }
end

def average_by_category(expenses)
  grouped = expenses.group_by { |expense| expense[:category] }
  grouped.transform_values { |category| category.reduce(0) { |sum, expense| sum + expense[:amount] } / category.length }
end

if $PROGRAM_NAME == __FILE__
  puts total_amount(expenses)
  p totals_by_category(expenses)
  p largest_expense(expenses)
  p average_by_category(expenses)
end

# frozen_string_literal: true

require 'bigdecimal'
require 'date'
require 'minitest/autorun'
require_relative 'expense_importer'

class ExpenseImporterTest < Minitest::Test
  def test_imports_expenses_from_csv
    expenses = imported_expenses

    assert_equal 2, expenses.size
    assert_instance_of Expense, expenses.first
  end

  def test_imports_first_expense_date
    assert_equal Date.new(2026, 5, 1), first_expense.date
  end

  def test_imports_first_expense_category
    assert_equal 'food', first_expense.category
  end

  def test_imports_first_expense_description
    assert_equal 'Lunch', first_expense.description
  end

  def test_imports_first_expense_amount
    assert_equal BigDecimal('12.50'), first_expense.amount
  end

  private

  def first_expense
    imported_expenses.first
  end

  def imported_expenses
    path = File.expand_path('fixtures/expenses.csv', __dir__)

    ExpenseImporter.from_csv(path)
  end
end

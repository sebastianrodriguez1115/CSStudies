# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'expense_analyzer'

class ExpenseAnalyzerTest < Minitest::Test
  def expenses
    [
      { category: 'food', amount: 12.50 },
      { category: 'books', amount: 20.00 },
      { category: 'food', amount: 7.25 },
      { category: 'transport', amount: 5.00 }
    ]
  end

  def test_total_amount
    assert_equal 44.75, total_amount(expenses)
  end

  def test_totals_by_category
    expected = {
      'food' => 19.75,
      'books' => 20.0,
      'transport' => 5.0
    }

    assert_equal expected, totals_by_category(expenses)
  end

  def test_largest_expense
    expected = { category: 'books', amount: 20.0 }

    assert_equal expected, largest_expense(expenses)
  end

  def test_average_by_category
    expected = {
      'food' => 9.875,
      'books' => 20.0,
      'transport' => 5.0
    }

    assert_equal expected, average_by_category(expenses)
  end
end

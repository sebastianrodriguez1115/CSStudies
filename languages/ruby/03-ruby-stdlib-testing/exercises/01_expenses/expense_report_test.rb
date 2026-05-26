# frozen_string_literal: true

require 'bigdecimal'
require 'date'
require 'minitest/autorun'
require_relative 'expense'
require_relative 'expense_report'

class ExpenseReportTest < Minitest::Test
  def test_renders_expenses_as_html
    html = ExpenseReport.render([expense])

    assert_includes html, '<table>'
    assert_includes html, 'Date'
    assert_includes html, 'Category'
    assert_includes html, 'Description'
    assert_includes html, 'Amount'
    assert_includes html, '2026-05-01'
    assert_includes html, 'food'
    assert_includes html, 'Lunch'
    assert_includes html, '12.5'
  end

  private

  def expense
    Expense.new(
      date: Date.new(2026, 5, 1),
      category: 'food',
      description: 'Lunch',
      amount: BigDecimal('12.50')
    )
  end
end

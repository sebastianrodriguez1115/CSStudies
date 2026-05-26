# frozen_string_literal: true

require 'bigdecimal'
require 'date'
require 'json'
require 'minitest/autorun'
require_relative 'expense'
require_relative 'expense_exporter'

class ExpenseExporterTest < Minitest::Test
  def test_exports_expenses_to_json
    json = ExpenseExporter.to_json([expense])

    assert_equal [expected_expense], JSON.parse(json)
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

  def expected_expense
    {
      'date' => '2026-05-01',
      'category' => 'food',
      'description' => 'Lunch',
      'amount' => '12.5'
    }
  end
end

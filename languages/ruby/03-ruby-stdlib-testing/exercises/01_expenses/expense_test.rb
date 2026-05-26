# frozen_string_literal: true

require 'bigdecimal'
require 'date'
require 'minitest/autorun'
require_relative 'expense'

class ExpenseTest < Minitest::Test
  def test_rejects_date_that_is_not_a_date
    error = assert_raises(ArgumentError) do
      build_expense(date: '2026-05-01')
    end

    assert_equal 'date must be a Date', error.message
  end

  def test_rejects_amount_that_is_not_a_big_decimal
    error = assert_raises(ArgumentError) do
      build_expense(amount: '12.50')
    end

    assert_equal 'amount must be a BigDecimal', error.message
  end

  def test_rejects_zero_amount
    error = assert_raises(ArgumentError) do
      build_expense(amount: BigDecimal('0'))
    end

    assert_equal 'amount must be greater than 0', error.message
  end

  def test_rejects_empty_category
    error = assert_raises(ArgumentError) do
      build_expense(category: '')
    end

    assert_equal 'category cannot be empty', error.message
  end

  def test_rejects_blank_category
    error = assert_raises(ArgumentError) do
      build_expense(category: '   ')
    end

    assert_equal 'category cannot be empty', error.message
  end

  def test_rejects_empty_description
    error = assert_raises(ArgumentError) do
      build_expense(description: '')
    end

    assert_equal 'description cannot be empty', error.message
  end

  def test_rejects_blank_description
    error = assert_raises(ArgumentError) do
      build_expense(description: '   ')
    end

    assert_equal 'description cannot be empty', error.message
  end

  def test_converts_to_hash
    expected = {
      date: '2026-05-01',
      category: 'food',
      description: 'Lunch',
      amount: '12.5'
    }

    assert_equal expected, build_expense.to_h
  end

  private

  def build_expense(overrides = {})
    defaults = {
      date: Date.new(2026, 5, 1),
      category: 'food',
      description: 'Lunch',
      amount: BigDecimal('12.50')
    }

    Expense.new(**defaults, **overrides)
  end
end

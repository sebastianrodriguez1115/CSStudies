# frozen_string_literal: true

require_relative 'money_test_helper'

class MoneyValueTest < Minitest::Test
  def test_keeps_amount_and_currency
    money = Money.new(10, 'USD')

    assert_equal 10, money.amount
    assert_equal 'USD', money.currency
  end

  def test_formats_as_amount_and_currency
    money = Money.new(10, 'USD')

    assert_equal '10 USD', money.to_s
  end

  def test_equal_when_amount_and_currency_match
    first = Money.new(10, 'USD')
    second = Money.new(10, 'USD')

    assert_equal first, second
  end

  def test_not_equal_when_amount_differs
    first = Money.new(10, 'USD')
    second = Money.new(20, 'USD')

    refute_equal first, second
  end

  def test_not_equal_when_currency_differs
    first = Money.new(10, 'USD')
    second = Money.new(10, 'EUR')

    refute_equal first, second
  end

  def test_not_equal_to_other_type
    money = Money.new(10, 'USD')

    refute_equal money, 10
  end

  def test_currency_normalization
    money = Money.new(10, 'usd')

    assert_equal 'USD', money.currency
  end

  def test_currency_normalization_removes_extra_spaces
    money = Money.new(10, ' usd ')

    assert_equal 'USD', money.currency
  end

  def test_errors_cannot_be_mutated_from_outside
    money = Money.new(10, 'USD')

    assert_raises(FrozenError) do
      money.errors << 'fake error'
    end

    assert_empty money.errors
  end
end

# frozen_string_literal: true

require_relative 'money_test_helper'

class MoneyArithmeticTest < Minitest::Test
  def test_adds_money_with_same_currency
    first = Money.new(10, 'USD')
    second = Money.new(5, 'USD')

    total = first + second

    assert_equal Money.new(15, 'USD'), total
  end

  def test_cannot_add_money_with_different_currency
    first = Money.new(10, 'USD')
    second = Money.new(5, 'EUR')

    assert_raises(Money::CurrencyMismatchError) do
      first + second
    end
  end

  def test_cannot_add_non_money
    money = Money.new(10, 'USD')

    assert_raises(TypeError) do
      money + 5
    end
  end

  def test_add_does_not_mutate_original_money
    first = Money.new(10, 'USD')
    second = Money.new(5, 'USD')

    assert_equal Money.new(15, 'USD'), first + second
    assert_equal Money.new(10, 'USD'), first
    assert_equal Money.new(5, 'USD'), second
  end

  def test_subtracts_money_with_same_currency
    first = Money.new(10, 'USD')
    second = Money.new(4, 'USD')

    result = first - second

    assert_equal Money.new(6, 'USD'), result
  end

  def test_cannot_subtract_more_than_available
    first = Money.new(10, 'USD')
    second = Money.new(15, 'USD')

    assert_raises(Money::InsufficientFundsError) do
      first - second
    end
  end

  def test_cannot_subtract_money_with_different_currency
    first = Money.new(10, 'USD')
    second = Money.new(5, 'EUR')

    assert_raises(Money::CurrencyMismatchError) do
      first - second
    end
  end

  def test_cannot_subtract_non_money
    money = Money.new(10, 'USD')

    assert_raises(TypeError) do
      money - 5
    end
  end

  def test_subtract_does_not_mutate_original_money
    first = Money.new(10, 'USD')
    second = Money.new(4, 'USD')

    assert_equal Money.new(6, 'USD'), first - second
    assert_equal Money.new(10, 'USD'), first
    assert_equal Money.new(4, 'USD'), second
  end
end

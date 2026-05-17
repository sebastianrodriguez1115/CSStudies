# frozen_string_literal: true

require_relative 'money_test_helper'

class MoneyValidationTest < Minitest::Test
  def test_valid_when_amount_is_non_negative_and_currency_is_present
    money = Money.new(10, 'USD')

    assert money.valid?
  end

  def test_invalid_when_amount_is_negative
    money = Money.new(-10, 'USD')

    refute money.valid?
    assert_includes money.errors, 'Amount should be non-negative.'
  end

  def test_invalid_when_amount_is_not_numeric
    money = Money.new('10', 'USD')

    refute money.valid?
    assert_includes money.errors, 'Amount should be numeric.'
  end

  def test_invalid_when_currency_is_nil
    money = Money.new(10, nil)

    refute money.valid?
    assert_includes money.errors, 'Currency should be provided.'
  end

  def test_invalid_when_currency_is_empty
    money = Money.new(10, '')

    refute money.valid?
    assert_includes money.errors, 'Currency should be provided.'
  end

  def test_valid_does_not_duplicate_errors
    money = Money.new(-10, nil)

    money.valid?
    money.valid?

    assert_equal [
      'Amount should be non-negative.',
      'Currency should be provided.'
    ], money.errors
  end
end

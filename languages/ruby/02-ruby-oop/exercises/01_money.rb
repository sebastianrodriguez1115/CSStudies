# frozen_string_literal: true

class Money
  attr_reader :amount, :currency, :errors

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
    @errors = []
  end

  def to_s
    "#{amount} #{currency}"
  end

  def valid?
    validate
    @errors.empty?
  end

  def ==(other)
    other.is_a?(Money) &&
      amount == other.amount &&
      currency == other.currency
  end

  private

  def validate
    @errors.clear
    validate_amount
    validate_currency
  end

  def validate_amount
    return if amount >= 0

    @errors << 'Amount should be non-negative.'
  end

  def validate_currency
    return if currency && !currency.empty?

    @errors << 'Currency should be provided.'
  end
end

if $PROGRAM_NAME == __FILE__
  price = Money.new(10, 'USD')

  p '10 USD'
  p price.amount
  p price.currency
  puts price
  puts price.valid?
  p price.errors

  p '-10 USD'
  price = Money.new(-10, 'USD')
  puts price.valid?
  p price.errors

  p '10 USD nil currency'
  price = Money.new(10, nil)
  puts price.valid?
  p price.errors

  same_price = Money.new(10, 'USD')
  another_same_price = Money.new(10, 'USD')
  different_price = Money.new(20, 'USD')

  p same_price == another_same_price
  p same_price == different_price
end

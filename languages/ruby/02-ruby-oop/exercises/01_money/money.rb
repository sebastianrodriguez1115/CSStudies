# frozen_string_literal: true

class Money
  class CurrencyMismatchError < StandardError; end
  class InsufficientFundsError < StandardError; end

  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = amount
    @currency = currency&.strip&.upcase
    @errors = []
  end

  def to_s
    "#{amount} #{currency}"
  end

  def valid?
    validate
    @errors.empty?
  end

  def errors
    @errors.dup.freeze
  end

  def ==(other)
    other.is_a?(Money) &&
      amount == other.amount &&
      currency == other.currency
  end

  def +(other)
    validate_operand(other)

    Money.new(amount + other.amount, currency)
  end

  def -(other)
    validate_operand(other)
    raise InsufficientFundsError if amount < other.amount

    Money.new(amount - other.amount, currency)
  end

  private

  def validate
    @errors.clear
    validate_amount
    validate_currency
  end

  def validate_amount
    unless amount.is_a?(Numeric)
      @errors << 'Amount should be numeric.'
      return
    end

    @errors << 'Amount should be non-negative.' if amount.negative?
  end

  def validate_currency
    @errors << 'Currency should be provided.' if !currency || currency.empty?
  end

  def validate_operand(other)
    raise TypeError unless other.is_a?(Money)
    raise CurrencyMismatchError unless currency == other.currency
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

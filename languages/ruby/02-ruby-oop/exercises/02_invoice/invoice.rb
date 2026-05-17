# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require_relative '../01_money/money'

class Invoice
  def initialize(currency)
    raise ArgumentError unless currency.present?

    @currency = currency.strip.upcase
    @items = []
  end

  def add_item(description:, quantity:, unit_price:)
    validate_item(description, quantity, unit_price)

    @items << {
      description: description,
      quantity: quantity,
      unit_price: unit_price
    }
  end

  def total
    amount = @items.sum { |item| item[:quantity] * item[:unit_price].amount }
    Money.new(amount, @currency)
  end

  private

  attr_reader :items

  def validate_item(description, quantity, unit_price)
    raise TypeError unless unit_price.is_a?(Money)
    raise Money::CurrencyMismatchError if @currency != unit_price.currency

    raise TypeError unless quantity.is_a?(Numeric)
    raise ArgumentError unless quantity.positive?

    raise ArgumentError unless description.present?
  end
end

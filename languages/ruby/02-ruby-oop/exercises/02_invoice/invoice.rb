# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require_relative '../01_money/money'
require_relative 'line_item'
require_relative 'payable'

class Invoice
  include Payable

  class InvalidCurrencyError < StandardError; end

  def initialize(currency)
    raise TypeError unless currency.is_a?(String)
    raise InvalidCurrencyError unless currency.present?

    @currency = currency.strip.upcase
    @items = []
  end

  def add_item(description:, quantity:, unit_price:)
    line_item = LineItem.new(
      description: description,
      quantity: quantity,
      unit_price: unit_price
    )

    raise Money::CurrencyMismatchError if @currency != line_item.currency

    @items << line_item

    self
  end

  def payable?
    @items.any?
  end

  def total
    @items.reduce(Money.new(0, @currency)) { |sum, item| sum + item.subtotal }
  end
end

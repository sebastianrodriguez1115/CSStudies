# frozen_string_literal: true

class LineItem
  def initialize(description:, quantity:, unit_price:)
    validate_item(description, quantity, unit_price)

    @description = description
    @quantity = quantity
    @unit_price = unit_price
  end

  def currency
    @unit_price.currency
  end

  def subtotal
    Money.new(@quantity * @unit_price.amount, currency)
  end

  private

  def validate_item(description, quantity, unit_price)
    raise TypeError unless unit_price.is_a?(Money)

    raise TypeError unless quantity.is_a?(Numeric)
    raise ArgumentError unless quantity.positive?

    raise TypeError unless description.is_a?(String)
    raise ArgumentError unless description.present?
  end
end

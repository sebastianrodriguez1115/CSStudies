# frozen_string_literal: true

require_relative 'invoice_test_helper'

class LineItemTest < Minitest::Test
  def test_subtotal
    line_item = LineItem.new(description: 'Book', quantity: 2, unit_price: Money.new(10, 'USD'))

    assert_equal Money.new(20, 'USD'), line_item.subtotal
  end

  def test_subtotal_with_decimal_quantity
    line_item = LineItem.new(description: 'Consulting hours', quantity: 1.5, unit_price: Money.new(100, 'USD'))

    assert_equal Money.new(150, 'USD'), line_item.subtotal
  end

  def test_currency
    line_item = LineItem.new(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))

    assert_equal 'USD', line_item.currency
  end

  def test_cannot_create_item_without_money_unit_price
    assert_raises(TypeError) do
      LineItem.new(description: 'Book', quantity: 2, unit_price: 10)
    end
  end

  def test_cannot_create_item_with_non_positive_quantity
    assert_raises(LineItem::InvalidQuantityError) do
      LineItem.new(description: 'Book', quantity: 0, unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_create_item_with_non_numeric_quantity
    assert_raises(TypeError) do
      LineItem.new(description: 'Book', quantity: '2', unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_create_item_with_empty_description
    assert_raises(LineItem::InvalidDescriptionError) do
      LineItem.new(description: '', quantity: 2, unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_create_item_with_blank_description
    assert_raises(LineItem::InvalidDescriptionError) do
      LineItem.new(description: '      ', quantity: 2, unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_create_item_with_nil_description
    assert_raises(TypeError) do
      LineItem.new(description: nil, quantity: 2, unit_price: Money.new(10, 'USD'))
    end
  end
end

# frozen_string_literal: true

require_relative 'invoice_test_helper'

class InvoiceItemValidationTest < Minitest::Test
  def test_cannot_add_item_with_different_currency
    invoice = Invoice.new('USD')

    assert_raises(Money::CurrencyMismatchError) do
      invoice.add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'EUR'))
    end
  end

  def test_cannot_add_item_without_money_unit_price
    invoice = Invoice.new('USD')

    assert_raises(TypeError) do
      invoice.add_item(description: 'Book', quantity: 1, unit_price: 10)
    end
  end

  def test_cannot_add_item_with_non_positive_quantity
    invoice = Invoice.new('USD')

    assert_raises(ArgumentError) do
      invoice.add_item(description: 'Book', quantity: 0, unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_add_item_with_non_numeric_quantity
    invoice = Invoice.new('USD')

    assert_raises(TypeError) do
      invoice.add_item(description: 'Book', quantity: '2', unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_add_item_with_empty_description
    invoice = Invoice.new('USD')

    assert_raises(ArgumentError) do
      invoice.add_item(description: '', quantity: 1, unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_add_item_with_nil_description
    invoice = Invoice.new('USD')

    assert_raises(ArgumentError) do
      invoice.add_item(description: nil, quantity: 1, unit_price: Money.new(10, 'USD'))
    end
  end

  def test_cannot_add_item_with_blank_description
    invoice = Invoice.new('USD')

    assert_raises(ArgumentError) do
      invoice.add_item(description: '   ', quantity: 1, unit_price: Money.new(10, 'USD'))
    end
  end
end

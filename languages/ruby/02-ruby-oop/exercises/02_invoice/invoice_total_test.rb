# frozen_string_literal: true

require_relative 'invoice_test_helper'

class InvoiceTotalTest < Minitest::Test
  def test_total_with_one_line_item
    invoice = Invoice.new('USD')

    invoice.add_item(description: 'Book', quantity: 2, unit_price: Money.new(10, 'USD'))

    assert_equal Money.new(20, 'USD'), invoice.total
  end

  def test_total_with_multiple_line_items
    invoice = Invoice.new('USD')

    invoice.add_item(description: 'Book', quantity: 2, unit_price: Money.new(10, 'USD'))
    invoice.add_item(description: 'Pen', quantity: 3, unit_price: Money.new(2, 'USD'))

    assert_equal Money.new(26, 'USD'), invoice.total
  end

  def test_total_with_decimal_quantity
    invoice = Invoice.new('USD')

    invoice.add_item(description: 'Consulting hours', quantity: 1.5, unit_price: Money.new(100, 'USD'))

    assert_equal Money.new(150, 'USD'), invoice.total
  end

  def test_previous_total_does_not_change_after_adding_more_items
    invoice = Invoice.new('USD')
    invoice.add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))

    previous_total = invoice.total
    invoice.add_item(description: 'Pen', quantity: 1, unit_price: Money.new(2, 'USD'))

    assert_equal Money.new(10, 'USD'), previous_total
    assert_equal Money.new(12, 'USD'), invoice.total
  end
end

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
end

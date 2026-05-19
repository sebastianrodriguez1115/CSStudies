# frozen_string_literal: true

require_relative 'invoice_test_helper'

class InvoiceAddItemTest < Minitest::Test
  def test_add_item_returns_invoice
    invoice = Invoice.new('USD')

    result = invoice.add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))

    assert_same invoice, result
  end

  def test_add_item_can_be_chained
    invoice = Invoice.new('USD')

    invoice
      .add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))
      .add_item(description: 'Pen', quantity: 2, unit_price: Money.new(1, 'USD'))

    assert_equal Money.new(12, 'USD'), invoice.total
  end
end

# frozen_string_literal: true

require_relative 'invoice_test_helper'

class InvoicePayableTest < Minitest::Test
  def test_invoice_without_items_is_not_payable
    invoice = Invoice.new('USD')

    refute invoice.payable?
  end

  def test_invoice_with_items_is_payable
    invoice = Invoice.new('USD')

    invoice.add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))

    assert invoice.payable?
  end

  def test_cannot_pay_invoice_without_items
    invoice = Invoice.new('USD')

    assert_raises(Payable::NotPayableError) do
      invoice.pay!
    end
  end

  def test_invoice_with_items_can_be_paid
    invoice = Invoice.new('USD')
    invoice.add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))

    invoice.pay!

    assert invoice.paid?
  end
end

# frozen_string_literal: true

require_relative 'invoice_test_helper'

class InvoiceCreationTest < Minitest::Test
  def test_new_invoice_starts_with_zero_total
    invoice = Invoice.new('USD')

    assert_equal Money.new(0, 'USD'), invoice.total
  end

  def test_invoice_currency_is_normalized_before_comparing_items
    invoice = Invoice.new(' usd ')

    invoice.add_item(description: 'Book', quantity: 1, unit_price: Money.new(10, 'USD'))

    assert_equal Money.new(10, 'USD'), invoice.total
  end

  def test_cannot_create_invoice_with_nil_currency
    assert_raises(ArgumentError) do
      Invoice.new(nil)
    end
  end

  def test_cannot_create_invoice_with_blank_currency
    assert_raises(ArgumentError) do
      Invoice.new('   ')
    end
  end
end

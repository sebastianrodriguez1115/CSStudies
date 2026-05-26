# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'payable'

class PayableTest < Minitest::Test
  PayableClass = Class.new do
    include Payable
  end

  NonPayableClass = Class.new do
    include Payable

    def payable?
      false
    end
  end

  def test_payable_starts_unpaid
    payable = PayableClass.new

    refute payable.paid?
  end

  def test_payable_is_payable_by_default
    payable = PayableClass.new

    assert payable.payable?
  end

  def test_payable_can_be_marked_as_paid
    payable = PayableClass.new

    payable.pay!

    assert payable.paid?
  end

  def test_cannot_pay_when_not_payable
    payable = NonPayableClass.new

    assert_raises(Payable::NotPayableError) do
      payable.pay!
    end
  end

  def test_pay_returns_payable_object
    payable = PayableClass.new

    result = payable.pay!

    assert_same payable, result
  end
end

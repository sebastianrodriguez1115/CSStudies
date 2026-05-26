# frozen_string_literal: true

module Payable
  class NotPayableError < StandardError; end

  def pay!
    raise NotPayableError unless payable?

    @paid = true

    self
  end

  def paid?
    @paid == true
  end

  def payable?
    true
  end
end

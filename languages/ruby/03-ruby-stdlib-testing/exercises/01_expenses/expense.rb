# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'bigdecimal'
require 'date'

class Expense
  attr_reader :date, :category, :description, :amount

  def initialize(date:, category:, description:, amount:)
    raise ArgumentError, 'date must be a Date' unless date.is_a?(Date)
    raise ArgumentError, 'amount must be a BigDecimal' unless amount.is_a?(BigDecimal)
    raise ArgumentError, 'amount must be greater than 0' unless amount.positive?
    raise ArgumentError, 'category cannot be empty' if category.blank?
    raise ArgumentError, 'description cannot be empty' if description.blank?

    @date = date
    @category = category
    @description = description
    @amount = amount
  end

  def to_h
    {
      date: date.iso8601,
      category: category,
      description: description,
      amount: amount.to_s('F')
    }
  end
end

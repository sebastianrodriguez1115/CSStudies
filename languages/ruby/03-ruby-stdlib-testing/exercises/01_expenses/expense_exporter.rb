# frozen_string_literal: true

require 'json'

class ExpenseExporter
  def self.to_json(expenses)
    JSON.generate(expenses.map(&:to_h))
  end
end

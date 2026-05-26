# frozen_string_literal: true

require 'bigdecimal'
require 'csv'
require 'date'
require_relative 'expense'

class ExpenseImporter
  def self.from_csv(path)
    CSV.read(path, headers: true).map do |row|
      Expense.new(
        date: Date.parse(row['date']),
        category: row['category'],
        description: row['description'],
        amount: BigDecimal(row['amount'])
      )
    end
  end
end

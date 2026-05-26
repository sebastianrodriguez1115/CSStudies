# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'statement'

class StatementTest < Minitest::Test
  def test_statement_output
    assert_equal expected_statement, Statement.statement(invoice, plays)
  end

  def test_statement_uses_invoice_customer
    invoice = self.invoice.merge(customer: 'SmallCo')

    assert_includes Statement.statement(invoice, plays), "Statement for SmallCo\n"
  end

  private

  def plays
    {
      'hamlet' => { name: 'Hamlet', type: 'tragedy' },
      'as-like' => { name: 'As You Like It', type: 'comedy' }
    }
  end

  def invoice
    {
      customer: 'BigCo',
      performances: [
        { play_id: 'hamlet', audience: 55 },
        { play_id: 'as-like', audience: 35 }
      ]
    }
  end

  def expected_statement
    <<~STATEMENT
      Statement for BigCo
        Hamlet: $650.00 (55 seats)
        As You Like It: $580.00 (35 seats)
      Amount owed is $1,230.00
      You earned 37 points
    STATEMENT
  end
end

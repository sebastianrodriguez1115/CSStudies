# frozen_string_literal: true

require 'erb'

class ExpenseReport
  TEMPLATE = <<~HTML
    <table>
      <thead>
        <tr>
          <th>Date</th>
          <th>Category</th>
          <th>Description</th>
          <th>Amount</th>
        </tr>
      </thead>
      <tbody>
        <% expenses.map(&:to_h).each do |expense| %>
          <tr>
            <td><%= expense[:date] %></td>
            <td><%= expense[:category] %></td>
            <td><%= expense[:description] %></td>
            <td><%= expense[:amount] %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
  HTML

  def self.render(expenses)
    ERB.new(TEMPLATE).result_with_hash(expenses: expenses)
  end
end

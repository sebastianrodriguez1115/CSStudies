# frozen_string_literal: true

require 'active_support'
require 'active_support/number_helper'
require_relative 'performance_summary'

module Statement
  module_function

  def statement(invoice, plays)
    performance_summaries = build_performance_summaries(invoice[:performances], plays)

    build_statement(
      invoice[:customer],
      performance_summaries,
      total_amount(performance_summaries),
      total_points(performance_summaries)
    )
  end

  def build_performance_summaries(performances, plays)
    performances.map do |performance|
      play = plays[performance[:play_id]]

      PerformanceSummary.new(
        play_name: play[:name],
        play_type: play[:type],
        audience: performance[:audience]
      )
    end
  end

  def total_amount(performance_summaries)
    performance_summaries.sum(&:payment)
  end

  def total_points(performance_summaries)
    performance_summaries.sum(&:points)
  end

  def build_statement(customer, performance_summaries, total_amount, points)
    <<~STATEMENT
      Statement for #{customer}
      #{build_plays_statement(performance_summaries)}
      Amount owed is #{format_money(total_amount)}
      You earned #{points} points
    STATEMENT
  end

  def build_plays_statement(performance_summaries)
    lines = performance_summaries.map { |summary| build_performance_line(summary) }

    lines.join("\n")
  end

  def build_performance_line(summary)
    "  #{summary.play_name}: #{format_money(summary.payment)} (#{summary.audience} seats)"
  end

  def format_money(cents)
    ActiveSupport::NumberHelper.number_to_currency(cents / 100.0)
  end
end

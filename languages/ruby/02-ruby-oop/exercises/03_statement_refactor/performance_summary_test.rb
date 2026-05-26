# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'performance_summary'

class PerformanceSummaryTest < Minitest::Test
  def test_keeps_play_name
    summary = PerformanceSummary.new(play_name: 'Hamlet', play_type: 'tragedy', audience: 55)

    assert_equal 'Hamlet', summary.play_name
  end

  def test_keeps_audience
    summary = PerformanceSummary.new(play_name: 'Hamlet', play_type: 'tragedy', audience: 55)

    assert_equal 55, summary.audience
  end

  def test_tragedy_payment
    summary = PerformanceSummary.new(play_name: 'Hamlet', play_type: 'tragedy', audience: 55)

    assert_equal 65_000, summary.payment
  end

  def test_comedy_payment
    summary = PerformanceSummary.new(play_name: 'As You Like It', play_type: 'comedy', audience: 35)

    assert_equal 58_000, summary.payment
  end

  def test_tragedy_points
    summary = PerformanceSummary.new(play_name: 'Hamlet', play_type: 'tragedy', audience: 55)

    assert_equal 25, summary.points
  end

  def test_comedy_points
    summary = PerformanceSummary.new(play_name: 'As You Like It', play_type: 'comedy', audience: 35)

    assert_equal 12, summary.points
  end
end

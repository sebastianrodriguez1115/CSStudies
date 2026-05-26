# frozen_string_literal: true

class PerformanceSummary
  attr_reader :play_name, :audience

  def initialize(play_name:, play_type:, audience:)
    @play_name = play_name
    @play_type = play_type
    @audience = audience
  end

  def payment
    case play_type
    when 'tragedy'
      tragedy_payment
    when 'comedy'
      comedy_payment
    end
  end

  def points
    points = 0
    points += audience - 30 if audience > 30
    points += audience.div(5) if play_type == 'comedy'
    points
  end

  private

  attr_reader :play_type

  def tragedy_payment
    amount = 40_000
    amount += 1_000 * (audience - 30) if audience > 30
    amount
  end

  def comedy_payment
    amount = 30_000
    amount += 10_000 + (500 * (audience - 20)) if audience > 20
    amount + (300 * audience)
  end
end

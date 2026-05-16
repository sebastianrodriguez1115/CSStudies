# frozen_string_literal: true

require 'minitest/autorun'

class MoneyTest < Minitest::Test
  MONEY_PATH = File.expand_path('01_money.rb', __dir__)

  def setup
    capture_io { load MONEY_PATH }
  end

  def test_loading_file_has_no_output
    output, error = capture_io { load MONEY_PATH }

    assert_equal '', output
    assert_equal '', error
  end
end

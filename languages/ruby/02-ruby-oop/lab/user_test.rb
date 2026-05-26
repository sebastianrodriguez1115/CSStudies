# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'user'

class UserTest < Minitest::Test
  def test_cannot_create_user_without_id
    assert_raises(User::InvalidIdError) do
      User.new(nil, 'user1')
    end
  end

  def test_cannot_create_user_with_blank_username
    assert_raises(User::InvalidUsernameError) do
      User.new(1, '   ')
    end
  end
end

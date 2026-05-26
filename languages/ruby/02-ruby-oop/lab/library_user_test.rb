# frozen_string_literal: true

require_relative 'library_test_helper'

class LibraryUserTest < Minitest::Test
  include LibraryTestHelper

  def test_add_user
    library_service = library
    user = User.new(3, 'new_username')

    assert_nil library_service.find_user(user.id)

    library_service.add_user(user)

    returned_user = library_service.find_user(user.id)
    assert_equal returned_user.username, 'new_username'
  end

  def test_add_user_returns_library_service
    library_service = library
    user = User.new(3, 'new_username')

    result = library_service.add_user(user)

    assert_same library_service, result
  end

  def test_add_user_failure_with_other_type
    assert_raises(LibraryService::InvalidUserError) do
      library.add_user('User?')
    end
  end

  def test_cannot_add_user_with_duplicate_id
    library_service = library
    duplicate = User.new(1, 'fake_user')

    result = library_service.add_user(duplicate)

    assert_nil result
    assert_equal 'user1', library_service.find_user(1).username
  end

  def test_find_user
    returned_user = library.find_user(2)

    assert_equal returned_user.username, 'user2'
  end

  def test_find_user_failure_with_not_present_id
    assert_nil library.find_user(999)
  end
end

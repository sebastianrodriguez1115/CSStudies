# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'borrowed_book'

class BorrowedBookTest < Minitest::Test
  def test_cannot_create_borrowed_book_without_book_id
    assert_raises(BorrowedBook::InvalidBookIdError) do
      BorrowedBook.new(nil, 1)
    end
  end

  def test_cannot_create_borrowed_book_without_user_id
    assert_raises(BorrowedBook::InvalidUserIdError) do
      BorrowedBook.new(1, nil)
    end
  end
end

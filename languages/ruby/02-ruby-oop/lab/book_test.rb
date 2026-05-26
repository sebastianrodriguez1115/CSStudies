# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'book'

class BookTest < Minitest::Test
  def test_cannot_create_book_without_id
    assert_raises(Book::InvalidIdError) do
      Book.new(nil, 'Hamlet')
    end
  end

  def test_cannot_create_book_with_blank_name
    assert_raises(Book::InvalidNameError) do
      Book.new(1, '   ')
    end
  end

  def test_not_equal_to_other_type
    book = Book.new(1, 'Hamlet')

    refute_equal book, 'Hamlet'
  end
end

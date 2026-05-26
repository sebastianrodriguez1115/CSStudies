# frozen_string_literal: true

require_relative 'library_test_helper'

class LibraryCatalogTest < Minitest::Test
  include LibraryTestHelper

  def test_add_book
    library_service = library
    book = Book.new(4, 'Added book')

    assert_nil library_service.find_book(book.id)

    library_service.add_book(book)

    returned_book = library_service.find_book(book.id)
    assert_equal returned_book.name, 'Added book'
  end

  def test_add_book_returns_library_service
    library_service = library
    book = Book.new(4, 'Added book')

    result = library_service.add_book(book)

    assert_same library_service, result
  end

  def test_add_book_failure_with_other_type
    assert_raises(LibraryService::InvalidBookError) do
      library.add_book('Book?')
    end
  end

  def test_cannot_add_book_with_duplicate_id
    library_service = library
    duplicate = Book.new(1, 'Fake Hamlet')

    result = library_service.add_book(duplicate)

    assert_nil result
    assert_equal 'Hamlet', library_service.find_book(1).name
  end

  def test_find_book
    returned_book = library.find_book(2)

    assert_equal returned_book.name, 'Another book'
  end

  def test_find_book_failure_with_not_present_id
    assert_nil library.find_book(999)
  end

  def test_available_books
    available_books = library.available_books
    assert_equal available_books, books
  end

  def test_available_books_with_borrowed
    library_service = library
    borrowed_book = library_service.borrow_book(1, 1)

    refute_includes library_service.available_books, borrowed_book
    assert_includes library_service.available_books, Book.new(2, 'Another book')
    assert_includes library_service.available_books, Book.new(3, 'Death note')
  end

  def test_book_available
    assert library.book_available?(1)
  end

  def test_book_available_false_book_not_present
    refute library.book_available?(999)
  end
end

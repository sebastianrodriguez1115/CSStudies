# frozen_string_literal: true

require_relative 'library_test_helper'

class LibraryBorrowingTest < Minitest::Test
  include LibraryTestHelper

  def test_borrow_book
    library_service = library
    assert library_service.book_available?(1)

    book = library_service.borrow_book(1, 1)

    assert_same library_service.find_book(1), book
    assert_equal book.name, 'Hamlet'
    refute library_service.book_available?(1)
  end

  def test_borrow_book_failure_book_not_present
    assert_raises(LibraryService::BookNotFoundError) do
      library.borrow_book(999, 1)
    end
  end

  def test_borrow_book_failure_user_not_present
    assert_raises(LibraryService::UserNotFoundError) do
      library.borrow_book(1, 999)
    end
  end

  def test_borrow_book_failure_already_borrowed
    library_service = library
    assert library_service.book_available?(1)

    book = library_service.borrow_book(1, 1)

    assert_equal book.name, 'Hamlet'
    assert_raises(LibraryService::BookNotAvailableError) do
      library_service.borrow_book(1, 1)
    end
  end

  def test_return_book
    library_service = library
    book = library_service.borrow_book(1, 1)

    refute library_service.book_available?(book.id)

    result = library_service.return_book(book, 1)

    assert_same library_service, result
    assert library_service.book_available?(book.id)
  end

  def test_return_book_failure_with_different_user
    library_service = library
    book = library_service.borrow_book(1, 1)

    assert_raises(LibraryService::WrongBorrowerError) do
      library_service.return_book(book, 2)
    end

    refute library_service.book_available?(book.id)
  end

  def test_return_book_failure_user_not_present
    library_service = library
    book = library_service.borrow_book(1, 1)

    assert_raises(LibraryService::UserNotFoundError) do
      library_service.return_book(book, 999)
    end

    refute library_service.book_available?(book.id)
  end

  def test_return_book_failure_book_not_in_catalog
    library_service = library
    book = Book.new(999, 'Unknown book')

    assert_raises(LibraryService::BookNotFoundError) do
      library_service.return_book(book, 1)
    end
  end

  def test_return_book_failure_book_not_borrowed
    library_service = library
    book = library_service.find_book(1)

    assert_raises(LibraryService::BookNotBorrowedError) do
      library_service.return_book(book, 1)
    end

    assert library_service.book_available?(book.id)
  end
end

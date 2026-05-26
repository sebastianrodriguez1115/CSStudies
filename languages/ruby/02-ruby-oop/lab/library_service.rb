# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require_relative 'book'
require_relative 'borrowed_book'
require_relative 'user'

class LibraryService
  class InvalidBookError < StandardError; end
  class InvalidUserError < StandardError; end
  class BookNotFoundError < StandardError; end
  class UserNotFoundError < StandardError; end
  class BookNotAvailableError < StandardError; end
  class BookNotBorrowedError < StandardError; end
  class WrongBorrowerError < StandardError; end

  def initialize
    @books = []
    @borrowed_books = []
    @users = []
  end

  def add_book(book)
    raise InvalidBookError unless book.is_a?(Book)
    return if find_book(book.id).present?

    @books << book

    self
  end

  def add_user(user)
    raise InvalidUserError unless user.is_a?(User)
    return if find_user(user.id).present?

    @users << user

    self
  end

  def available_books
    @books.reject { |book| borrowed?(book.id) }
  end

  def book_available?(book_id)
    book = find_book(book_id)

    return false unless book.present?

    !borrowed?(book_id)
  end

  def borrow_book(book_id, user_id)
    raise BookNotFoundError unless find_book(book_id).present?
    raise UserNotFoundError unless find_user(user_id).present?
    raise BookNotAvailableError unless book_available?(book_id)

    @borrowed_books << BorrowedBook.new(book_id, user_id)
    find_book(book_id)
  end

  def find_book(book_id)
    @books.find { |book| book.id == book_id }
  end

  def find_user(user_id)
    @users.find { |user| user.id == user_id }
  end

  def return_book(book, user_id)
    validate_return!(book, user_id)

    borrowed_book = find_borrowed_book(book.id, user_id)
    raise WrongBorrowerError unless borrowed_book.present?

    @borrowed_books.delete(borrowed_book)

    self
  end

  private

  def borrowed?(book_id)
    @borrowed_books.any? { |borrowed_book| borrowed_book.book_id == book_id }
  end

  def find_borrowed_book(book_id, user_id)
    @borrowed_books.find do |borrowed_book|
      borrowed_book.book_id == book_id && borrowed_book.user_id == user_id
    end
  end

  def validate_return!(book, user_id)
    raise InvalidBookError unless book.is_a?(Book)
    raise UserNotFoundError unless find_user(user_id).present?
    raise BookNotFoundError unless find_book(book.id).present?
    raise BookNotBorrowedError unless borrowed?(book.id)
  end
end

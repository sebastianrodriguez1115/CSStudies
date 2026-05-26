# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'library_service'

module LibraryTestHelper
  private

  def books
    [
      Book.new(1, 'Hamlet'),
      Book.new(2, 'Another book'),
      Book.new(3, 'Death note')
    ]
  end

  def users
    [
      User.new(1, 'user1'),
      User.new(2, 'user2')
    ]
  end

  def library
    library_service = LibraryService.new

    books.each { |book| library_service.add_book(book) }
    users.each { |user| library_service.add_user(user) }

    library_service
  end
end

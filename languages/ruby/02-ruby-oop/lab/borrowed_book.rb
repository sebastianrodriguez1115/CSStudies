# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class BorrowedBook
  class InvalidBookIdError < StandardError; end
  class InvalidUserIdError < StandardError; end

  attr_reader :book_id, :user_id

  def initialize(book_id, user_id)
    raise InvalidBookIdError if book_id.blank?
    raise InvalidUserIdError if user_id.blank?

    @book_id = book_id
    @user_id = user_id
  end
end

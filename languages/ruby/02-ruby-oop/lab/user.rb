# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class User
  class InvalidIdError < StandardError; end
  class InvalidUsernameError < StandardError; end

  attr_reader :id, :username

  def initialize(id, username)
    raise InvalidIdError if id.blank?
    raise InvalidUsernameError if username.blank?

    @id = id
    @username = username.strip
  end
end

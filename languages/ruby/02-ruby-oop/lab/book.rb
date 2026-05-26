# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class Book
  class InvalidIdError < StandardError; end
  class InvalidNameError < StandardError; end

  attr_reader :id, :name

  def initialize(id, name)
    raise InvalidIdError if id.blank?
    raise InvalidNameError if name.blank?

    @id = id
    @name = name.strip
  end

  def ==(other)
    other.is_a?(Book) &&
      id == other.id &&
      name == other.name
  end
end

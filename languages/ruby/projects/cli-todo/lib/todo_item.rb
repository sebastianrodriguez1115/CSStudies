# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class TodoItem
  attr_reader :id, :title

  def self.from_h(attributes)
    item = new(id: attributes.fetch(:id), title: attributes.fetch(:title))
    item.complete! if attributes.fetch(:completed)
    item
  end

  def initialize(id:, title:)
    raise ArgumentError, 'title cannot be blank' if title.blank?

    @id = id
    @title = title
    @completed = false
  end

  def complete!
    @completed = true
  end

  def completed?
    @completed
  end

  def rename!(title)
    raise ArgumentError, 'title cannot be blank' if title.blank?

    @title = title
  end

  def reopen!
    @completed = false
  end

  def to_h
    {
      id: id,
      title: title,
      completed: completed?
    }
  end
end

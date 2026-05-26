# frozen_string_literal: true

require 'json'
require 'securerandom'
require_relative 'todo_item'

class TodoList
  class ItemNotFound < StandardError; end

  def self.from_json(json)
    items = JSON.parse(json, symbolize_names: true).map do |item_attributes|
      TodoItem.from_h(item_attributes)
    end

    new(items: items)
  end

  def initialize(items: [])
    @items = items.dup
  end

  def add(title:)
    item = TodoItem.new(id: SecureRandom.uuid, title: title)
    @items << item
    item
  end

  def clear_completed
    @items.reject!(&:completed?)
    items
  end

  def complete(id)
    item = find!(id)
    item.complete!
    item
  end

  def completed_items
    @items.select(&:completed?)
  end

  def find(id)
    @items.find { |item| item.id == id }
  end

  def find!(id)
    item = find(id)
    raise ItemNotFound, 'todo item not found' if item.nil?

    item
  end

  def items
    @items.dup
  end

  def pending_items
    @items.reject(&:completed?)
  end

  def remove(id)
    item = find!(id)
    @items.delete(item)
  end

  def rename(id, title:)
    item = find!(id)
    item.rename!(title)
    item
  end

  def reopen(id)
    item = find!(id)
    item.reopen!
    item
  end

  def to_a
    @items.map(&:to_h)
  end

  def to_json(*)
    JSON.generate(to_a)
  end
end

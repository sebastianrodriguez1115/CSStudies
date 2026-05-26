# frozen_string_literal: true

require_relative 'todo_list'

class TodoJsonStore
  def initialize(file_path:)
    @file_path = file_path
  end

  def load
    return TodoList.new unless File.exist?(@file_path)

    TodoList.from_json(File.read(@file_path))
  end

  def save(list)
    File.write(@file_path, list.to_json)
  end
end

# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class TodoCLI
  ID_REQUIRED_MESSAGE = 'Id is required'
  TITLE_REQUIRED_MESSAGE = 'Title is required'

  def initialize(store:, output: $stdout)
    @store = store
    @output = output
  end

  def run(argv)
    command, *arguments = argv
    return @output.puts('Usage: todo <command>') if command.nil?

    run_command(command, arguments)
  end

  private

  def run_command(command, arguments)
    action = commands[command]
    return @output.puts("Unknown command: #{command}") if action.nil?

    action.call(arguments)
  end

  def add(arguments)
    title = required_title(arguments)
    return if title.nil?

    list = @store.load
    item = list.add(title:)
    @store.save(list)

    @output.puts "Added #{item.id}: #{item.title}"
  end

  def clear_completed(_arguments)
    list = @store.load
    removed_count = list.completed_items.size
    list.clear_completed
    @store.save(list)

    @output.puts "Removed #{removed_count} completed items"
  end

  def complete(arguments)
    mutate_item(arguments, :complete, 'Completed')
  end

  def commands
    {
      'add' => method(:add),
      'clear-completed' => method(:clear_completed),
      'complete' => method(:complete),
      'list' => method(:list),
      'remove' => method(:remove),
      'rename' => method(:rename),
      'reopen' => method(:reopen)
    }
  end

  def list(arguments)
    items_for(@store.load, arguments).each do |item|
      @output.puts "#{status_marker(item)} #{item.id} #{item.title}"
    end
  end

  def remove(arguments)
    mutate_item(arguments, :remove, 'Removed')
  end

  def rename(arguments)
    id = required_id(arguments)
    return if id.nil?

    title = required_title(arguments.drop(1))
    return if title.nil?

    list = @store.load
    item = list.rename(id, title:)
    @store.save(list)

    @output.puts "Renamed #{item.id}: #{item.title}"
  end

  def reopen(arguments)
    mutate_item(arguments, :reopen, 'Reopened')
  end

  def mutate_item(arguments, action, message)
    id = required_id(arguments)
    return if id.nil?

    list = @store.load
    item = list.public_send(action, id)
    @store.save(list)

    @output.puts "#{message} #{item.id}: #{item.title}"
  end

  def required_id(arguments)
    required_value(arguments.first, ID_REQUIRED_MESSAGE)
  end

  def required_title(arguments)
    required_value(arguments.join(' '), TITLE_REQUIRED_MESSAGE)
  end

  def required_value(value, message)
    return value unless value.blank?

    @output.puts message
    nil
  end

  def status_marker(item)
    item.completed? ? '[x]' : '[ ]'
  end

  def items_for(todo_list, arguments)
    case arguments.first
    when 'completed'
      todo_list.completed_items
    when 'pending'
      todo_list.pending_items
    else
      todo_list.items
    end
  end
end

# frozen_string_literal: true

require 'fileutils'
require 'stringio'
require 'tmpdir'
require_relative '../lib/todo_cli'
require_relative '../lib/todo_json_store'
require_relative '../lib/todo_list'

RSpec.describe TodoCLI do
  describe '#run' do
    subject(:cli) { described_class.new(store:, output:) }

    let(:directory) { Dir.mktmpdir }
    let(:file_path) { File.join(directory, 'todos.json') }
    let(:output) { StringIO.new }
    let(:store) { TodoJsonStore.new(file_path:) }

    after do
      FileUtils.remove_entry(directory)
    end

    it 'adds an item' do
      cli.run(['add', 'Buy milk'])

      item = store.load.items.first
      expect(item.title).to eq('Buy milk')
      expect(output.string).to eq("Added #{item.id}: Buy milk\n")
    end

    it 'prints a message when add title is missing' do
      cli.run(['add'])

      expect(output.string).to eq("Title is required\n")
    end

    it 'prints a message when complete id is missing' do
      cli.run(['complete'])

      expect(output.string).to eq("Id is required\n")
    end

    it 'prints usage when no command is given' do
      cli.run([])

      expect(output.string).to eq("Usage: todo <command>\n")
    end

    it 'prints a message for an unknown command' do
      cli.run(['nope'])

      expect(output.string).to eq("Unknown command: nope\n")
    end

    it 'prints a message when remove id is missing' do
      cli.run(['remove'])

      expect(output.string).to eq("Id is required\n")
    end

    it 'prints a message when rename id is missing' do
      cli.run(['rename'])

      expect(output.string).to eq("Id is required\n")
    end

    it 'prints a message when reopen id is missing' do
      cli.run(['reopen'])

      expect(output.string).to eq("Id is required\n")
    end

    context 'with an existing item' do
      let(:item) { store.load.items.first }
      let(:list) { TodoList.new }

      before do
        list.add(title: 'Buy milk')
        store.save(list)
      end

      it 'completes an item' do
        cli.run(['complete', item.id])

        completed_item = store.load.find!(item.id)
        expect(completed_item).to be_completed
        expect(output.string).to eq("Completed #{item.id}: Buy milk\n")
      end

      it 'removes an item' do
        cli.run(['remove', item.id])

        expect(store.load.items).to eq([])
        expect(output.string).to eq("Removed #{item.id}: Buy milk\n")
      end

      it 'renames an item' do
        cli.run(['rename', item.id, 'Read', 'docs'])

        renamed_item = store.load.find!(item.id)
        expect(renamed_item.title).to eq('Read docs')
        expect(output.string).to eq("Renamed #{item.id}: Read docs\n")
      end

      it 'prints a message when rename title is missing' do
        cli.run(['rename', item.id])

        expect(output.string).to eq("Title is required\n")
      end

      it 'reopens an item' do
        list.complete(item.id)
        store.save(list)

        cli.run(['reopen', item.id])

        reopened_item = store.load.find!(item.id)
        expect(reopened_item).not_to be_completed
        expect(output.string).to eq("Reopened #{item.id}: Buy milk\n")
      end
    end

    context 'with pending and completed items' do
      let(:completed_item) { store.load.completed_items.first }
      let(:list) { TodoList.new }
      let(:pending_item) { store.load.pending_items.first }

      before do
        list.add(title: 'Buy milk')
        item = list.add(title: 'Read docs')
        item.complete!
        store.save(list)
      end

      it 'clears completed items' do
        cli.run(['clear-completed'])

        expect(store.load.to_a).to eq([pending_item.to_h])
        expect(output.string).to eq("Removed 1 completed items\n")
      end

      it 'lists items' do
        cli.run(['list'])

        expect(output.string).to eq(
          "[ ] #{pending_item.id} Buy milk\n" \
          "[x] #{completed_item.id} Read docs\n"
        )
      end

      it 'lists completed items' do
        cli.run(%w[list completed])

        expect(output.string).to eq("[x] #{completed_item.id} Read docs\n")
      end

      it 'lists pending items' do
        cli.run(%w[list pending])

        expect(output.string).to eq("[ ] #{pending_item.id} Buy milk\n")
      end
    end
  end
end

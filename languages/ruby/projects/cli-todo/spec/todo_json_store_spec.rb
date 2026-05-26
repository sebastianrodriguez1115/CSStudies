# frozen_string_literal: true

require 'json'
require 'tmpdir'
require_relative '../lib/todo_json_store'
require_relative '../lib/todo_list'

RSpec.describe TodoJsonStore do
  describe '#load' do
    it 'loads a list from JSON' do
      Dir.mktmpdir do |directory|
        file_path = File.join(directory, 'todos.json')
        store = described_class.new(file_path:)
        saved_list = TodoList.new
        item = saved_list.add(title: 'Buy milk')
        item.complete!
        store.save(saved_list)

        loaded_list = store.load

        expect(loaded_list.to_a).to eq(saved_list.to_a)
      end
    end

    it 'returns an empty list when the file does not exist' do
      Dir.mktmpdir do |directory|
        file_path = File.join(directory, 'todos.json')
        store = described_class.new(file_path:)

        list = store.load

        expect(list.items).to eq([])
      end
    end
  end

  describe '#save' do
    it 'writes the list as JSON' do
      Dir.mktmpdir do |directory|
        file_path = File.join(directory, 'todos.json')
        store = described_class.new(file_path:)
        list = TodoList.new
        item = list.add(title: 'Buy milk')

        store.save(list)

        json = File.read(file_path)
        expect(JSON.parse(json, symbolize_names: true)).to eq([item.to_h])
      end
    end
  end
end

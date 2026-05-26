# frozen_string_literal: true

require 'json'
require_relative '../lib/todo_list'

RSpec.describe TodoList do
  describe '.from_json' do
    it 'builds a list from JSON' do
      json = JSON.generate(
        [
          {
            id: 'item-id',
            title: 'Buy milk',
            completed: true
          }
        ]
      )

      list = described_class.from_json(json)

      expect(list.to_a).to eq(
        [
          {
            id: 'item-id',
            title: 'Buy milk',
            completed: true
          }
        ]
      )
    end
  end

  describe '#add' do
    it 'returns the added item' do
      list = described_class.new

      item = list.add(title: 'Buy milk')

      expect(item).to eq(list.items.first)
    end

    it 'assigns a unique id to each added item' do
      list = described_class.new

      first_item = list.add(title: 'Buy milk')
      second_item = list.add(title: 'Read docs')

      expect(first_item.id).not_to eq(second_item.id)
    end
  end

  describe '#clear_completed' do
    it 'removes completed items and returns remaining items' do
      list = described_class.new
      pending_item = list.add(title: 'Buy milk')
      completed_item = list.add(title: 'Read docs')

      completed_item.complete!

      remaining_items = list.clear_completed

      expect(remaining_items).to eq([pending_item])
      expect(list.items).to eq([pending_item])
    end
  end

  describe '#complete' do
    it 'marks the item with the given id as completed' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      list.complete(item.id)

      expect(item).to be_completed
    end

    it 'returns the completed item' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      completed_item = list.complete(item.id)

      expect(completed_item).to eq(item)
    end
  end

  describe '#completed_items' do
    it 'lists completed items' do
      list = described_class.new
      list.add(title: 'Buy milk')
      completed_item = list.add(title: 'Read docs')

      completed_item.complete!

      expect(list.completed_items).to eq([completed_item])
    end
  end

  describe '#find' do
    it 'returns the item with the given id' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      expect(list.find(item.id)).to eq(item)
    end

    it 'returns nil when the item does not exist' do
      list = described_class.new

      expect(list.find('missing-id')).to be_nil
    end
  end

  describe '#find!' do
    it 'returns the item with the given id' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      expect(list.find!(item.id)).to eq(item)
    end

    it 'raises an item not found error when the item does not exist' do
      list = described_class.new

      expect { list.find!('missing-id') }
        .to raise_error(described_class::ItemNotFound, 'todo item not found')
    end
  end

  describe '#items' do
    it 'lists added items' do
      list = described_class.new

      item = list.add(title: 'Buy milk')

      expect(list.items).to eq([item])
    end
  end

  describe '#pending_items' do
    it 'lists pending items' do
      list = described_class.new
      pending_item = list.add(title: 'Buy milk')
      completed_item = list.add(title: 'Read docs')

      completed_item.complete!

      expect(list.pending_items).to eq([pending_item])
    end
  end

  describe '#remove' do
    it 'removes the item with the given id' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      expect(list.items).to eq([item])

      list.remove(item.id)

      expect(list.items).to eq([])
    end

    it 'returns the removed item' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      removed_item = list.remove(item.id)

      expect(removed_item).to eq(item)
    end
  end

  describe '#rename' do
    it 'renames the item with the given id' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      list.rename(item.id, title: 'Read docs')

      expect(item.title).to eq('Read docs')
    end

    it 'returns the renamed item' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      renamed_item = list.rename(item.id, title: 'Read docs')

      expect(renamed_item).to eq(item)
    end
  end

  describe '#reopen' do
    it 'marks the item with the given id as pending' do
      list = described_class.new
      item = list.add(title: 'Buy milk')
      item.complete!

      list.reopen(item.id)

      expect(item).not_to be_completed
    end

    it 'returns the reopened item' do
      list = described_class.new
      item = list.add(title: 'Buy milk')
      item.complete!

      reopened_item = list.reopen(item.id)

      expect(reopened_item).to eq(item)
    end
  end

  describe '#to_a' do
    it 'returns an array representation' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      expect(list.to_a).to eq([item.to_h])
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation' do
      list = described_class.new
      item = list.add(title: 'Buy milk')

      expect(JSON.parse(list.to_json, symbolize_names: true)).to eq([item.to_h])
    end
  end
end

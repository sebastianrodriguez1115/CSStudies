# frozen_string_literal: true

require_relative '../lib/todo_item'

RSpec.describe TodoItem do
  describe '.from_h' do
    it 'builds an item from a hash' do
      item = described_class.from_h(
        id: 'item-id',
        title: 'Buy milk',
        completed: true
      )

      expect(item.id).to eq('item-id')
      expect(item.title).to eq('Buy milk')
      expect(item).to be_completed
    end
  end

  describe '#complete!' do
    it 'can be completed' do
      item = described_class.new(id: 1, title: 'Buy milk')

      item.complete!

      expect(item).to be_completed
    end
  end

  describe '#completed?' do
    it 'starts pending' do
      item = described_class.new(id: 1, title: 'Buy milk')

      expect(item).not_to be_completed
    end
  end

  describe '#initialize' do
    it 'stores the id' do
      item = described_class.new(id: 1, title: 'Buy milk')

      expect(item.id).to eq(1)
    end

    it 'stores the title' do
      item = described_class.new(id: 1, title: 'Buy milk')

      expect(item.title).to eq('Buy milk')
    end

    it 'rejects an empty title' do
      expect { described_class.new(id: 1, title: '') }
        .to raise_error(ArgumentError, 'title cannot be blank')
    end

    it 'rejects a blank title' do
      expect { described_class.new(id: 1, title: '   ') }
        .to raise_error(ArgumentError, 'title cannot be blank')
    end
  end

  describe '#rename!' do
    it 'changes the title' do
      item = described_class.new(id: 1, title: 'Buy milk')

      item.rename!('Read docs')

      expect(item.title).to eq('Read docs')
    end
  end

  describe '#reopen!' do
    it 'marks the item as pending' do
      item = described_class.new(id: 1, title: 'Buy milk')
      item.complete!

      item.reopen!

      expect(item).not_to be_completed
    end
  end

  describe '#to_h' do
    it 'returns a hash representation' do
      item = described_class.new(id: 'item-id', title: 'Buy milk')
      item.complete!

      expect(item.to_h).to eq(
        id: 'item-id',
        title: 'Buy milk',
        completed: true
      )
    end
  end
end

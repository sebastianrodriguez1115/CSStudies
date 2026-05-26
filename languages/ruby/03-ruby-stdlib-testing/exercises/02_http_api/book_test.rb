# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'book'

class BookTest < Minitest::Test
  def test_rejects_blank_title
    error = assert_raises(ArgumentError) do
      build_book(title: '   ')
    end

    assert_equal 'title cannot be blank', error.message
  end

  def test_rejects_blank_author
    error = assert_raises(ArgumentError) do
      build_book(author: '   ')
    end

    assert_equal 'author cannot be blank', error.message
  end

  def test_rejects_pages_that_are_not_an_integer
    error = assert_raises(ArgumentError) do
      build_book(pages: '652')
    end

    assert_equal 'pages must be an Integer', error.message
  end

  def test_rejects_pages_that_are_not_positive
    error = assert_raises(ArgumentError) do
      build_book(pages: 0)
    end

    assert_equal 'pages must be greater than 0', error.message
  end

  def test_rejects_year_that_is_not_an_integer
    error = assert_raises(ArgumentError) do
      build_book(year: '2022')
    end

    assert_equal 'year must be an Integer', error.message
  end

  def test_rejects_year_that_is_not_positive
    error = assert_raises(ArgumentError) do
      build_book(year: 0)
    end

    assert_equal 'year must be greater than 0', error.message
  end

  private

  def build_book(overrides = {})
    defaults = {
      title: 'The Kubernetes Bible',
      author: 'Nassim Kebbani, Piotr Tylenda',
      pages: 652,
      year: 2022
    }

    Book.new(**defaults, **overrides)
  end
end

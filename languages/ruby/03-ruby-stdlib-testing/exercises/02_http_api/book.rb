# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class Book
  attr_reader :title, :author, :pages, :year

  def initialize(title:, author:, pages:, year:)
    raise ArgumentError, 'title cannot be blank' if title.blank?
    raise ArgumentError, 'author cannot be blank' if author.blank?
    raise ArgumentError, 'pages must be an Integer' unless pages.is_a?(Integer)
    raise ArgumentError, 'pages must be greater than 0' unless pages.positive?
    raise ArgumentError, 'year must be an Integer' unless year.is_a?(Integer)
    raise ArgumentError, 'year must be greater than 0' unless year.positive?

    @title = title
    @author = author
    @pages = pages
    @year = year
  end

  def to_h
    {
      title: title,
      author: author,
      pages: pages,
      year: year
    }
  end
end

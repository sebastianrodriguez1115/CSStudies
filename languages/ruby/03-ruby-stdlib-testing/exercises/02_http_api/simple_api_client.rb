# frozen_string_literal: true

require 'json'
require 'net/http'
require 'uri'
require_relative 'book'

class SimpleApiClient
  class HttpError < StandardError; end

  def initialize(base_url:, http: Net::HTTP)
    @base_url = base_url
    @http = http
  end

  def books
    response = http.get_response(URI.join(base_url, '/books'))
    raise HttpError, "GET /books failed with status #{response.code}" unless response.code == '200'

    payload = JSON.parse(response.body)

    payload.fetch('data').map { |book_data| build_book(book_data) }
  end

  private

  attr_reader :base_url, :http

  def build_book(book_data)
    Book.new(
      title: book_data.fetch('title'),
      author: book_data.fetch('author'),
      pages: book_data.fetch('pages'),
      year: book_data.fetch('year')
    )
  end
end

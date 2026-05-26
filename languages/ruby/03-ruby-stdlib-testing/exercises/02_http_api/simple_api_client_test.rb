# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require_relative 'simple_api_client'

class SimpleApiClientTest < Minitest::Test
  class FakeHttp
    Response = Struct.new(:code, :body, keyword_init: true)

    attr_reader :requested_uri

    def initialize(body:, code: '200')
      @body = body
      @code = code
    end

    def get_response(uri)
      @requested_uri = uri

      Response.new(code: @code, body: @body)
    end
  end

  def test_requests_books_endpoint
    client.books

    assert_equal '/books', http.requested_uri.path
  end

  def test_returns_books
    books = client.books

    assert_equal 1, books.size
    assert_instance_of Book, books.first
  end

  def test_maps_book_attributes
    assert_equal expected_book_attributes, client.books.first.to_h
  end

  def test_raises_error_when_books_request_fails
    error = assert_raises(SimpleApiClient::HttpError) do
      client_with_response(code: '500', body: error_response).books
    end

    assert_equal 'GET /books failed with status 500', error.message
  end

  private

  def client
    @client ||= SimpleApiClient.new(base_url: 'http://localhost:8080', http: http)
  end

  def http
    @http ||= FakeHttp.new(body: books_response)
  end

  def client_with_response(code:, body:)
    SimpleApiClient.new(
      base_url: 'http://localhost:8080',
      http: FakeHttp.new(code: code, body: body)
    )
  end

  def expected_book_attributes
    {
      title: 'The Kubernetes Bible',
      author: 'Nassim Kebbani, Piotr Tylenda',
      pages: 652,
      year: 2022
    }
  end

  def books_response
    JSON.generate(
      {
        success: true,
        code: 200,
        message: 'OK',
        error: nil,
        data: [expected_book_attributes]
      }
    )
  end

  def error_response
    JSON.generate(
      {
        success: false,
        code: 500,
        message: 'Internal Server Error',
        error: 'Something went wrong',
        data: nil
      }
    )
  end
end

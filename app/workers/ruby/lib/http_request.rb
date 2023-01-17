# frozen_string_literal: true

require 'set'
require 'faraday'

require_relative 'xml'
require_relative 'json'

# Send HTTP requests.
module HTTPRequest
  # @return [Set<Symbol>]
  METHODS = ::Set.new(%i[get head delete trace post put patch]).freeze

  class << self
    METHODS.each do |http_method|
      class_eval <<~CODE, __FILE__, __LINE__ + 1
        def #{http_method}(...)
          send(:#{http_method}, ...)
        end
      CODE
    end

    # @param http_method [Symbol, String]
    # @param params [Hash, nil]
    # @param headers [Hash, nil]
    # @param body [String, nil]
    # @param json [Hash, nil]
    # @param xml [Hash, nil]
    def send(http_method, url, params: nil, headers: nil, body: nil, json: nil, xml: nil) # rubocop:disable Metrics/ParameterLists
      body ||=
        if xml
          xml
        elsif json
          json
        end

      conn = ::Faraday.new(url:) do |c|
        if json
          c.request :json
          c.response :json
        elsif xml
          c.use ::XML::FaradayMiddleware
        end
      end

      conn.public_send(http_method) do |req|
        req.body = body
        req.params.merge(params) if params
        req.headers.merge(headers) if headers
      end
    end

    # @return [Set<Symbol>]
    def request_methods
      METHODS
    end
  end
end

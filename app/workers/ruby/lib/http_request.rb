# frozen_string_literal: true

require 'set'
require 'faraday'
require 'uri'

require_relative 'xml'
require_relative 'json'

# Send HTTP requests.
module HTTPRequest
  class InvalidProtocolError < ::StandardError; end

  # @return [Set<Symbol>]
  METHODS = ::Set.new(%i[get head delete trace post put patch]).freeze
  # @return [Set<String>]
  ALLOWED_SCHEMES = ::Set.new(%w[http https]).freeze

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
        if xml && xml != true
          xml
        elsif json && json != true
          json
        end

      parsed_uri = ::URI.parse(url)
      raise InvalidProtocolError, "Expected one of #{ALLOWED_SCHEMES.inspect}, got #{parsed_uri.scheme.inspect}" unless ALLOWED_SCHEMES.include?(parsed_uri.scheme)

      conn = ::Faraday.new(url:, headers:) do |c|
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
      end
    end

    # @return [Set<Symbol>]
    def request_methods
      METHODS
    end
  end
end

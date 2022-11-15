# frozen_string_literal: true

require 'faraday'

require_relative '../config/env_settings'

# Wraps the Lambdee API.
module LambdeeAPI
  class << self
    # @param authorisation [String]
    # @return [Faraday::Connection]
    def http_connection(authorisation: ::Config::LAMBDEE_API_AUTHORISATION_HEADER)
      ::Faraday.new(
        url: ::Config::LAMBDEE_API_URI,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => authorisation
        }
      )
    end
  end
end

# frozen_string_literal: true

require 'faraday'

module XML
  # Faraday middleware which encodes the request body
  # to XML and parses the response from XML to a Ruby hash.
  class FaradayMiddleware < ::Faraday::Middleware
    # Request building hook
    def on_request(env)
      env.request_body = ::XML.encode(env.request_body)
      env.request_headers.merge({ 'Content-Type' => 'application/xml' })
    end

    # Response parsing hook
    def on_complete(env)
      env.response_body = ::XML.parse(env.response_body)
    end
  end
end

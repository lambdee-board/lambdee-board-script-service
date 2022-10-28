# frozen_string_literal: true

# Wraps the Lambdee API.
module LambdeeAPI
  class << self
    # @return [Faraday::Connection]
    def http_connection
      ::Faraday.new(
        url: ::Config::LAMBDEE_API_URI,
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end

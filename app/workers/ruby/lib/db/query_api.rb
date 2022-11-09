# frozen_string_literal: true

module DB
  # Contains modules which provide
  # methods for defining associations
  # between database tables/records,
  # for fetching associated records etc.
  module QueryAPI
    # Base error class for the Query API
    class Error < ::StandardError
      # @return [Faraday::Response]
      attr_reader :response

      # @param response [Faraday::Response, nil]
      def initialize(response)
        message = response.body if response.respond_to?(:body)
        super message

        @response = response
      end

      alias response_body message

      # @return [Hash, nil]
      def json
        ::JSON.parse(response_body)
      rescue JSON::ParserError
        nil
      end
    end

    class InvalidQueryError < Error; end
    class InvalidRecordError < Error; end
    class ServerFailure < Error; end
  end
end

::Dir[::File.expand_path('query_api/*', __dir__)].each { require _1 }

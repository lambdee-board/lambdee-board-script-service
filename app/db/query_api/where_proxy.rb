# frozen_string_literal: true

require_relative 'where_methods'

module DB
  module QueryAPI
    # Proxy object returned from calling the `where` method
    # without arguments in the query API.
    class WhereProxy
      # @param query [DB::QueryAPI::Query, DB::QueryAPI::AndOrContext]
      def initialize(query)
        @query = query
      end

      # @param kwargs [Hash]
      # @return [DB::QueryAPI::Query, DB::QueryAPI::AndOrContext]
      def not(**kwargs)
        @query.where_query.merge! not: kwargs

        @query
      end
    end
  end
end

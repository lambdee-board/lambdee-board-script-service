# frozen_string_literal: true

require_relative 'where_methods'

module DB
  module QueryAPI
    # Context object used to evaluate blocks passed to
    # `and` and `or` methods in the query API.
    class AndOrContext
      include WhereMethods

      # @return [Hash]
      attr_reader :body

      # Initializes the body of the where expression.
      def initialize
        @body = {}
      end

      # @param value [Hash]
      def where_query=(value)
        @body = value
      end

      # @return [Hash]
      def where_query
        @body
      end
    end
  end
end

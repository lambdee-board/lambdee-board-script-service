# frozen_string_literal: true

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

      private

      def where_query=(value)
        @body = value
      end

      def where_query
        @body
      end
    end
  end
end

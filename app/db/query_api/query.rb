# rubocop:disable Style/OptionalBooleanParameter
# frozen_string_literal: true

require_relative 'where_methods'

module DB
  module QueryAPI
    # Object which represents a database query.
    class Query
      include WhereMethods

      # @return [Class]
      attr_reader :target_class
      # @return [Hash]
      attr_reader :body

      # @param target_class [Class]
      def initialize(target_class)
        @target_class = target_class
        @body = {
          type: @target_class.table_name,
          query: {}
        }
      end

      # @param elements [Integer]
      # @return [self]
      def limit(elements)
        append_to_query :limit, elements
        self
      end

      # @param elements [Integer]
      # @return [self]
      def offset(elements)
        append_to_query :offset, elements
        self
      end

      # @param kwargs [Hash{Symbol => Symbol}]
      # @return [self]
      def order(**kwargs)
        append_to_query :order, kwargs
        self
      end

      # @param args [Array<Symbol>]
      # @return [self]
      def group_by(*args)
        append_to_query :group_by, args
        self
      end

      alias group group_by

      # @param val [Boolean]
      # @return [self]
      def count(val = true)
        append_to_query :count, val
        self
      end

      # @param val [Boolean]
      # @return [self]
      def distinct(val = true)
        append_to_query :distinct, val
        self
      end

      # @param args [Array<Symbol, Hash{Symbol => Hash, Symbol, Array}]
      # @return [self]
      def join(*args)
        append_to_query :join, args
        self
      end

      alias joins join

      # @param args [Array<Symbol, Hash{Symbol => Hash, Symbol, Array}]
      # @return [self]
      def left_outer_join(*args)
        append_to_query :left_outer_join, args
        self
      end

      # @return [Boolean]
      def exist?
        limit(1).execute.any?
      end

      alias exists? exist?

      private

      def where_query=(value)
        @body[:query][:where] = value
      end

      def where_query
        @body[:query][:where]
      end

      # @param key [Symbol]
      # @param val [Object]
      def append_to_query(key, val)
        @body[:query][key] = val
      end
    end
  end
end

# rubocop:enable Style/OptionalBooleanParameter

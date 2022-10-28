# rubocop:disable Style/OptionalBooleanParameter
# frozen_string_literal: true

require 'faraday'
require 'json'

require_relative 'where_methods'
require_relative '../../../config/env_settings'

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

      # @return [Array<DB::BaseModel>, Object]
      def execute
        response = ::LambdeeAPI.http_connection.get('search') do |req|
          req.body = @body.to_json
        end

        raise InvalidQueryError, response if (300...500).include? response.status
        raise ServerFailure, response if response.status >= 500

        body = ::JSON.parse response.body
        return body['aggregation'] if body['aggregation']

        model = BaseModel.model_table_name_map[body['type'].to_sym]
        body['records'].map do |record|
          model.from_record(record)
        end
      end

      alias load execute

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
        limit(1).load.any?
      end

      # @return [Array]
      def to_a
        execute.to_a
      end

      alias exists? exist?

      def where_query=(value)
        @body[:query][:where] = value
      end

      def where_query
        @body[:query][:where]
      end

      private

      # @param key [Symbol]
      # @param val [Object]
      def append_to_query(key, val)
        @body[:query][key] = val
      end
    end
  end
end

# rubocop:enable Style/OptionalBooleanParameter

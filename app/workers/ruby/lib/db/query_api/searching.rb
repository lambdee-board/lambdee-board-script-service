# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods which search for
    # records with specified attributes/fields.
    module Searching
      # @return [Query]
      def all
        Query.new(self)
      end

      # @return [Query]
      def where(...)
        Query.new(self).where(...)
      end

      # @return [self, nil]
      def find(id)
        find_by(id:)
      end

      # @param id [Integer]
      # @return [Boolean]
      def exist?(id)
        !find(id).nil?
      end

      alias exists? exist?

      # @return [Query]
      def count
        Query.new(self).count
      end

      # @return [Query]
      def join(*args)
        Query.new(self).join(*args)
      end

      alias joins join

      # @return [Query]
      # @param args [Array<Symbol>]
      def left_outer_join(*args)
        Query.new(self).left_outer_join(*args)
      end

      # @return [Query]
      def distinct
        Query.new(self).distinct
      end

      # @param args [Array<Symbol>]
      # @return [Query]
      def group_by(*args)
        Query.new(self).group_by(*args)
      end

      # @param kwargs [Hash{Symbol => Symbol}]
      # @return [Query]
      def order(**kwargs)
        Query.new(self).order(**kwargs)
      end

      # @param elements [Integer]
      # @return [Query]
      def limit(elements)
        Query.new(self).limit(elements)
      end

      # @param elements [Integer]
      def offset(elements)
        Query.new(self).offset(elements)
      end

      alias group group_by

      # @return [self, nil]
      def find_by(**kwargs)
        Query.new(self).where(**kwargs).limit(1).execute.first
      end

      # @param elements [Integer]
      # @return [Array<self>, self, nil]
      def first(elements = 1)
        result = Query.new(self).limit(elements).order(id: :asc).execute
        elements == 1 ? result.first : result
      end

      # @param elements [Integer]
      # @return [Array<self>, self, nil]
      def last(elements = 1)
        result = Query.new(self).limit(elements).order(id: :desc).execute
        elements == 1 ? result.first : result
      end
    end
  end
end

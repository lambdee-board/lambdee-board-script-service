# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods which search for
    # records with specified attributes/fields.
    module Searching
      def all
        Query.new(self)
      end

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

      def count
        Query.new(self).count
      end

      def join(*args)
        Query.new(self).join(*args)
      end

      alias joins join

      def left_outer_join(*args)
        Query.new(self).left_outer_join(*args)
      end

      def distinct
        Query.new(self).distinct
      end

      def group_by(*args)
        Query.new(self).group_by(*args)
      end

      def order(**kwargs)
        Query.new(self).order(**kwargs)
      end

      def limit(elements)
        Query.new(self).limit(elements)
      end

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

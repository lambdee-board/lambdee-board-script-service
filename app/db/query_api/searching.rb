# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods which search for
    # records with specified attributes/fields.
    module Searching
      def where(...)
        Query.new.where(...)
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
        Query.new.count
      end

      def join(*args)
        Query.new.join(*args)
      end

      alias joins join

      def left_outer_join(*args)
        Query.new.left_outer_join(*args)
      end

      def distinct
        Query.new.distinct
      end

      def group_by(*args)
        Query.new.group_by(*args)
      end

      def order(**kwargs)
        Query.new.order(**kwargs)
      end

      def limit(elements)
        Query.new.limit(elements)
      end

      def offset(elements)
        Query.new.offset(elements)
      end

      alias group group_by

      # @return [self, nil]
      def find_by(**kwargs)
        Query.new.where(**kwargs).limit(1).execute.first
      end

      # @param elements [Integer]
      # @return [self, nil]
      def first(elements = 1)
        Query.new.limit(elements).order(id: :asc).execute.first
      end

      # @param elements [Integer]
      # @return [self, nil]
      def last(elements = 1)
        Query.new.limit(elements).order(id: :desc).execute.first
      end
    end
  end
end

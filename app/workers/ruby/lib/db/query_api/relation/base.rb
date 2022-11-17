# frozen_string_literal: true

require_relative '../../../hash_like_access'

module DB
  module QueryAPI
    module Relation
      # Represents a single relation between two tables.
      #
      #     class OneToMany < DB::QueryAPI::Relation::Base
      #       self.type = :one_to_many
      #     end
      #
      # @abstract Subclass to create a new relation type.
      class Base
        include ::HashLikeAccess

        class << self
          # @return [Symbol] Type of the relation.
          attr_accessor :type
        end

        # @return [Symbol]
        attr_reader :name
        # @return [Symbol]
        attr_reader :foreign_key

        # @param name [Symbol]
        # @param base_class [Class, String]
        # @param target_class [Class, String]
        # @param foreign_key [Symbol]
        def initialize(name, base_class:, target_class:, foreign_key:)
          @name = name
          @base_class = base_class
          @target_class = target_class
          @foreign_key = foreign_key
        end

        # @return [Symbol] Type of the relation.
        def type
          self.class.type
        end

        # @return [Hash]
        def to_h(_options = {})
          {
            name:,
            type:,
            base_class:,
            target_class:,
            foreign_key:
          }
        end
        alias to_hash to_h

        # @return [Class]
        def base_class
          return @base_class unless @base_class.is_a?(::String)

          @base_class = ::DB.const_get(@base_class)
        end

        # @return [Class]
        def target_class
          return @target_class unless @target_class.is_a?(::String)

          @target_class = ::DB.const_get(@target_class)
        end
      end
    end
  end
end

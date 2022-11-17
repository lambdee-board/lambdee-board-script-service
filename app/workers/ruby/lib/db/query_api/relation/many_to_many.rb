# frozen_string_literal: true

module DB
  module QueryAPI
    module Relation
      # Represents a many to many relation between two tables.
      class ManyToMany < Base
        self.type = :many_to_many

        # @return [DB::QueryAPI::Relation::Base]
        attr_reader :through

        # @param name [Symbol]
        # @param base_class [Class]
        # @param target_class [Class]
        # @param foreign_key [Symbol]
        # @param through [Symbol]
        def initialize(name, base_class:, target_class:, foreign_key:, through:)
          super(name, base_class:, target_class:, foreign_key:)
          @through = base_class.relations[through]
        end
      end
    end
  end
end

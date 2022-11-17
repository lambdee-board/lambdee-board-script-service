# frozen_string_literal: true

module DB
  module QueryAPI
    module Relation
      # Represents a many to one relation between two tables.
      class ManyToOne < Base
        self.type = :many_to_one
      end
    end
  end
end

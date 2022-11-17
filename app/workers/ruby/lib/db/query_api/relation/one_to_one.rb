# frozen_string_literal: true

module DB
  module QueryAPI
    module Relation
      # Represents a one to one relation between two tables.
      class OneToOne < Base
        self.type = :one_to_one
      end
    end
  end
end

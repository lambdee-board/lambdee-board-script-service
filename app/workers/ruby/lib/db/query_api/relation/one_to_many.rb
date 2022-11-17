# frozen_string_literal: true

module DB
  module QueryAPI
    module Relation
      # Represents a one to many relation between two tables.
      class OneToMany < Base
        self.type = :one_to_many
      end
    end
  end
end

# frozen_string_literal: true

module DB
  module QueryAPI
    # Contains classes which represent a single relation between two tables.
    module Relation; end
  end
end

require_relative 'relation/base'
require_relative 'relation/many_to_many'
require_relative 'relation/many_to_one'
require_relative 'relation/one_to_many'
require_relative 'relation/one_to_one'

# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual tags which
  # can be attached to tasks in the Lambdee Agile Board.
  class Tag < BaseModel
    # @!attribute [rw] name
    #   @return [String] Name of the task.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] colour
    #   @return [String] HEX colour of the board.
    attribute :colour, ::Shale::Type::String
  end
end

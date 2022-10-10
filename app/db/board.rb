# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual boards of some workspace.
  #
  # A Board contains Lists of Tasks.
  class Board < BaseModel
    # @!attribute [rw] name
    #   @return [String] Name of the workspace.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] colour
    #   @return [String] HEX colour of the board.
    attribute :colour, ::Shale::Type::String
    # @!attribute [rw] deleted_at
    #   @return [Time] When the board was deleted.
    attribute :deleted_at, ::Shale::Type::Time

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

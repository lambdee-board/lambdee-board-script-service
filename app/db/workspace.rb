# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual workspaces present in the Lambdee Agile Board.
  #
  # A Workspace is a collection of boards and
  # users who can access those boards.
  class Workspace < BaseModel
    # @!attribute [rw] name
    #   @return [String] Name of the workspace.
    attribute :name, ::Shale::Type::String

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

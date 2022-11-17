# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual boards of some workspace.
  #
  # A Board contains Lists of Tasks.
  class Board < BaseModel
    include QueryAPI::CustomData
    include QueryAPI::Deletable

    # @!attribute [rw] workspace_id
    #   @return [Integer] ID of the associated workspace.
    # @!attribute [rw] workspace
    #   @return [Workspace]
    belongs_to :workspace, 'Workspace'

    # @!attribute [r] lists
    #   @return [QueryAPI::Query]
    has_many :lists, 'List'
    # @!attribute [r] tags
    #   @return [QueryAPI::Query]
    has_many :tags, 'Tag'

    # @!attribute [rw] name
    #   @return [String] Name of the workspace.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] colour
    #   @return [String, nil] HEX colour of the board.
    attribute :colour, ::Shale::Type::String
  end
end

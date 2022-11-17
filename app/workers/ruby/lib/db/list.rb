# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual Lists in the Lambdee Agile Board.
  #
  # A List belongs to a Board,
  # and contains Tasks.
  class List < BaseModel
    include QueryAPI::CustomData
    include QueryAPI::Deletable
    include QueryAPI::Positionable

    # @!attribute [rw] board_id
    #   @return [Integer] ID of the associated board.
    # @!attribute [rw] board
    #   @return [Board]
    belongs_to :board, 'Board'

    # @!attribute [r] lists
    #   @return [QueryAPI::Query]
    has_many :tasks, 'Task'

    # @!attribute [rw] name
    #   @return [String] Name of the task.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] visible
    #   @return [Boolean] Whether this list
    #     is visible in the Board work view.
    attribute :visible, ::Shale::Type::String
  end
end

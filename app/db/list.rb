# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual Lists in the Lambdee Agile Board.
  #
  # A List belongs to a Board,
  # and contains Tasks.
  class List < BaseModel
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
    # @!attribute [rw] pos
    #   @return [Float] Floating point value
    #     which determines the position of this task
    #     in the List it belongs to.
    attribute :pos, ::Shale::Type::Float
    # @!attribute [rw] visible
    #   @return [Boolean] Whether this list
    #     is visible in the Board work view.
    attribute :visible, ::Shale::Type::String
    # @!attribute [rw] deleted_at
    #   @return [Time, nil] When the board was deleted.
    attribute :deleted_at, ::Shale::Type::Time

    alias position pos
    alias position= pos=

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual tags which
  # can be attached to tasks in the Lambdee Agile Board.
  class Tag < BaseModel
    include QueryAPI::CustomData

    # @!attribute [rw] board_id
    #   @return [Integer] ID of the associated board.
    # @!attribute [rw] board
    #   @return [Board]
    belongs_to :board, 'Board'

    # @!attribute [r] task_tags
    #   @return [QueryAPI::Query]
    has_many :task_tags, 'TaskTag'
    # @!attribute [r] tasks
    #   @return [QueryAPI::Query]
    has_many :tasks, 'Task', through: :task_tags

    # @!attribute [rw] name
    #   @return [String] Name of the task.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] colour
    #   @return [String] HEX colour of the board.
    attribute :colour, ::Shale::Type::String
  end
end

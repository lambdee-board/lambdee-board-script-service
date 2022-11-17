# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual Sprints in the Lambdee Agile Board.
  class Sprint < BaseModel
    include QueryAPI::CustomData

    # @!attribute [rw] board_id
    #   @return [Integer] ID of the associated board.
    # @!attribute [rw] board
    #   @return [Board]
    belongs_to :board, 'Board'
    # @!attribute [r] sprint_tasks
    #   @return [QueryAPI::Query]
    has_many :sprint_tasks, 'SprintTask'
    # @!attribute [r] tasks
    #   @return [QueryAPI::Query]
    has_many :tasks, 'Task', through: :sprint_tasks

    # @!attribute [rw] name
    #   @return [String, nil] Name of the sprint
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] description
    #   @return [String, nil] Description of the sprint
    #     formatted in Markdown.
    attribute :description, ::Shale::Type::String
    # @!attribute [rw] final_list_name
    #   @return [String, nil] Name of the list containing finished tasks.
    attribute :final_list_name, ::Shale::Type::String
    # @!attribute [rw] started_at
    #   @return [Time, nil] When the sprint was started.
    attribute :started_at, ::Shale::Type::Time
    # @!attribute [rw] expected_end_at
    #   @return [Time, nil] When the sprint is/was expected to end.
    attribute :expected_end_at, ::Shale::Type::Time
    # @!attribute [rw] ended_at
    #   @return [Time, nil] When the sprint ended.
    attribute :ended_at, ::Shale::Type::Time
  end
end

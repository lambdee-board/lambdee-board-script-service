# frozen_string_literal: true

module DB
  # Represents a many-to-many
  # relation between `Sprint` and `Task`.
  class SprintTask < BaseModel
    include QueryAPI::CustomData

    # @!attribute [rw] sprint_id
    #   @return [Integer] ID of the associated sprint.
    # @!attribute [rw] sprint
    #   @return [Sprint]
    belongs_to :sprint, 'Sprint'
    # @!attribute [rw] task_id
    #   @return [Integer] ID of the associated task.
    # @!attribute [rw] task
    #   @return [Task]
    belongs_to :task, 'Task'

    # @!attribute [rw] added_at
    #   @return [Time, nil] When the task was added to the sprint.
    attribute :added_at, ::Shale::Type::Time
    # @!attribute [rw] completed_at
    #   @return [Time, nil] When the task was completed.
    attribute :completed_at, ::Shale::Type::Time
    # @!attribute [rw] start_state
    #   @return [String, nil] Name of the task's state when it was added to the sprint.
    attribute :start_state, ::Shale::Type::String
    # @!attribute [rw] state
    #   @return [String, nil] Name of the task's state at the end of the sprint.
    attribute :state, ::Shale::Type::String
  end
end

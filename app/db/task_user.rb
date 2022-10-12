# frozen_string_literal: true

module DB
  # Represents a many-to-many
  # relation between `Task` and `User`.
  class TaskUser < BaseModel
    # @!attribute [rw] task_id
    #   @return [Integer] ID of the associated task.
    # @!attribute [rw] task
    #   @return [Task]
    belongs_to :task, 'Task'
    # @!attribute [rw] user_id
    #   @return [Integer] ID of the associated user.
    # @!attribute [rw] user
    #   @return [User]
    belongs_to :user, 'User'
  end
end

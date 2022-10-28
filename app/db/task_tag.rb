# frozen_string_literal: true

module DB
  # Represents a many-to-many
  # relation between `Task` and `Tag`.
  class TaskTag < BaseModel
    # @!attribute [rw] task_id
    #   @return [Integer] ID of the associated task.
    # @!attribute [rw] task
    #   @return [Task]
    belongs_to :task, 'Task'
    # @!attribute [rw] tag_id
    #   @return [Integer] ID of the associated tag.
    # @!attribute [rw] tag
    #   @return [Tag]
    belongs_to :tag, 'Tag'
  end
end

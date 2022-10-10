# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual tasks in the Lambdee Agile Board.
  #
  # A Task has an author (a user who created it),
  # it may have one or more assigned users,
  # and comments.
  class Task < BaseModel
    # @!attribute [rw] name
    #   @return [String] Name of the task.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] description
    #   @return [String] Description of the task.
    attribute :description, ::Shale::Type::String
    # @!attribute [rw] pos
    #   @return [Float] Floating point value
    #     which determines the position of this task
    #     in the List it belongs to.
    attribute :pos, ::Shale::Type::Float
    # @!attribute [rw] priority
    #   @return [String] Priority of the task.
    attribute :priority, ::Shale::Type::String
    # @!attribute [rw] points
    #   @return [Integer] Number of points assigned to this task.
    attribute :points, ::Shale::Type::String
    # @!attribute [rw] spent_time
    #   @return [Integer] Number of seconds spent on this task.
    attribute :spent_time, ::Shale::Type::String
    # @!attribute [rw] start_time
    #   @return [Time, nil] When the timer for this task has been started.
    attribute :start_time, ::Shale::Type::Time
    # @!attribute [rw] deleted_at
    #   @return [Time] When the board was deleted.
    attribute :deleted_at, ::Shale::Type::Time

    alias position pos
    alias position= pos=

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

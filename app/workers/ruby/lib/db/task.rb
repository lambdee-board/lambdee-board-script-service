# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual tasks in the Lambdee Agile Board.
  #
  # A Task has an author (a user who created it),
  # it may have one or more assigned users,
  # and comments.
  class Task < BaseModel
    include QueryAPI::CustomData
    include QueryAPI::Deletable
    include QueryAPI::Positionable

    # @return [Hash<]
    PRIORITIES = ::ActiveSupport::HashWithIndifferentAccess.new({
      very_low: 0,
      low: 1,
      medium: 2,
      high: 3,
      very_high: 4
    })

    # @!attribute [rw] author_id
    #   @return [Integer] ID of the associated author.
    # @!attribute [rw] author
    #   @return [User]
    belongs_to :author, 'User'
    # @!attribute [rw] list_id
    #   @return [Integer] ID of the associated list.
    # @!attribute [rw] list
    #   @return [List]
    belongs_to :list, 'List'

    # @!attribute [r] comments
    #   @return [QueryAPI::Query]
    has_many :comments, 'Comment'
    # @!attribute [r] task_users
    #   @return [QueryAPI::Query]
    has_many :task_users, 'TaskUser'
    # @!attribute [r] task_tags
    #   @return [QueryAPI::Query]
    has_many :task_tags, 'TaskTag'
    # @!attribute [r] users
    #   @return [QueryAPI::Query]
    has_many :users, 'User', through: :task_users
    # @!attribute [r] tags
    #   @return [QueryAPI::Query]
    has_many :tags, 'Tag', through: :task_tags

    # @!attribute [rw] name
    #   @return [String] Name of the task.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] description
    #   @return [String] Description of the task.
    attribute :description, ::Shale::Type::String
    # @!attribute [rw] priority
    #   @return [String] Priority of the task.
    attribute :priority, ::Shale::Type::String
    # @!attribute [rw] points
    #   @return [Integer] Number of points assigned to this task.
    attribute :points, ::Shale::Type::String
    # @!attribute [rw] spent_time
    #   @return [Integer] Number of seconds spent on this task.
    attribute :spent_time, ::Shale::Type::String
    # @!attribute [rw] spent_time
    #   @return [Integer] Number of seconds spent on this task.
    attribute :due_time, ::Shale::Type::Time
    # @!attribute [rw] due_time
    #   @return [Time, nil] Due time of this task.
    attribute :start_time, ::Shale::Type::Time

    # @return [Integer, nil]
    def priority_number
      PRIORITIES[priority]
    end
  end
end

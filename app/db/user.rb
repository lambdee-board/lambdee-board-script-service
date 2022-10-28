# frozen_string_literal: true

module DB
  # Instances of this class represent
  # users of the Lambdee Agile Board.
  class User < BaseModel
    # @!attribute [r] comments
    #   @return [QueryAPI::Query]
    has_many :comments, 'Comment'
    # @!attribute [r] created_tasks
    #   @return [QueryAPI::Query]
    has_many :created_tasks, 'Task', foreign_key: :author_id
    # @!attribute [r] task_users
    #   @return [QueryAPI::Query]
    has_many :task_users, 'TaskUser'
    # @!attribute [r] user_workspaces
    #   @return [QueryAPI::Query]
    has_many :user_workspaces, 'UserWorkspace'
    # @!attribute [r] tasks
    #   @return [QueryAPI::Query]
    has_many :tasks, 'Task', through: :task_users
    # @!attribute [r] workspaces
    #   @return [QueryAPI::Query]
    has_many :workspaces, 'Workspace', through: :user_workspaces

    # @!attribute [rw] name
    #   @return [String] Name of the user.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] email
    #   @return [String] Email of the user.
    attribute :email, ::Shale::Type::String
    # @!attribute [rw] password
    #   @return [String, nil] Password of the user.
    attribute :password, ::Shale::Type::String
    # @!attribute [rw] role
    #   @return [String] Role of the user.
    attribute :role, ::Shale::Type::String
    # @!attribute [rw] deleted_at
    #   @return [Time] When the user was deleted.
    attribute :deleted_at, ::Shale::Type::Time
    # TODO: nil values should be in `to_json`!

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

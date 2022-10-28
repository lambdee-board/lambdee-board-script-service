# frozen_string_literal: true

module DB
  # Represents a many-to-many
  # relation between `User` and `Workspace`.
  class UserWorkspace < BaseModel
    # @!attribute [rw] user_id
    #   @return [Integer] ID of the associated user.
    # @!attribute [rw] user
    #   @return [User]
    belongs_to :user, 'User'
    # @!attribute [rw] workspace_id
    #   @return [Integer] ID of the associated workspace.
    # @!attribute [rw] workspace
    #   @return [Workspace]
    belongs_to :workspace, 'Workspace'
  end
end

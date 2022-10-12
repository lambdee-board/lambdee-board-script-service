# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual Comment of a Task in the Lambdee Agile Board.
  #
  # A comment has an author (a User who created it)
  # and a Task to which it is attached.
  class Comment < BaseModel
    # @!attribute [rw] author_id
    #   @return [Integer] ID of the associated author.
    # @!attribute [rw] author
    #   @return [User]
    belongs_to :author, 'User'
    # @!attribute [rw] task_id
    #   @return [Integer] ID of the associated task.
    # @!attribute [rw] task
    #   @return [Task]
    belongs_to :task, 'Task'

    # @!attribute [rw] body
    #   @return [String, nil] Body of the comment
    #     formatted in Markdown.
    attribute :body, ::Shale::Type::String
    # @!attribute [rw] deleted_at
    #   @return [Time, nil] When the board was deleted.
    attribute :deleted_at, ::Shale::Type::Time

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

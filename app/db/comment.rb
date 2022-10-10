# frozen_string_literal: true

module DB
  # Instances of this class represent
  # individual Comment of a Task in the Lambdee Agile Board.
  #
  # A comment has an author (a User who created it)
  # and a Task to which it is attached.
  class Comment < BaseModel
    # @!attribute [rw] body
    #   @return [String] Body of the comment
    #     formatted in Markdown.
    attribute :body, ::Shale::Type::String
    # @!attribute [rw] deleted_at
    #   @return [Time] When the board was deleted.
    attribute :deleted_at, ::Shale::Type::Time

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

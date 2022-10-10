# frozen_string_literal: true

module DB
  # Instances of this class represent
  # users of the Lambdee Agile Board.
  class User < BaseModel
    # @!attribute [rw] name
    #   @return [String] Name of the user.
    attribute :name, ::Shale::Type::String
    # @!attribute [rw] email
    #   @return [String] Email of the user.
    attribute :email, ::Shale::Type::String
    # @!attribute [rw] role
    #   @return [String] Role of the user.
    attribute :role, ::Shale::Type::String
    # @!attribute [rw] deleted_at
    #   @return [Time] When the user was deleted.
    attribute :deleted_at, ::Shale::Type::Time

    # @return [Boolean]
    def deleted?
      !deleted_at.nil?
    end
  end
end

# frozen_string_literal: true

require 'shale'

require_relative 'query_api'

module DB
  # @abstract Subclass to define a new Database Model class
  #   which represents an SQL table
  class BaseModel < ::Shale::Mapper
    extend QueryAPI::Associations
    extend QueryAPI::Searching

    class << self
      attr_writer :table_name

      # @return [String]
      def table_name
        @table_name ||= "#{name.split('::').last.downcase}s"
      end
    end

    # @!attribute [r] id
    #   @return [Integer] ID of the record.
    attribute :id, ::Shale::Type::Integer
    # @!attribute [rw] created_at
    #   @return [Time] When the record was created.
    attribute :created_at, ::Shale::Type::Time
    # @!attribute [rw] updated_at
    #   @return [Time] When the record was last updated.
    attribute :updated_at, ::Shale::Type::Time
  end
end

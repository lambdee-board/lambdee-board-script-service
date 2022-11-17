# frozen_string_literal: true

require 'shale'

require_relative 'query_api'

module DB
  # @abstract Subclass to define a new Database Model class
  #   which represents an SQL table
  class BaseModel < ::Shale::Mapper
    extend QueryAPI::Associations
    extend QueryAPI::Searching
    extend QueryAPI::Persistence::ClassMethods
    include QueryAPI::Persistence::InstanceMethods

    # @return [Hash{Symbol => self}]
    @@model_table_name_map = {} # rubocop:disable Style/ClassVars

    class << self
      # @return [Symbol]
      attr_accessor :table_name

      # @param subclass [Class<self>]
      def inherited(subclass)
        super
        subclass.table_name = "#{subclass.name.split('::').last.underscore}s".to_sym
        @@model_table_name_map[subclass.table_name] = subclass
      end

      # @return [Hash{Symbol => self}]
      def model_table_name_map
        @@model_table_name_map
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

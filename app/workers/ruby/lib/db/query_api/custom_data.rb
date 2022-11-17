# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for handling custom user data
    # in DB records.
    module CustomData
      extend ::ActiveSupport::Concern

      included do
        extend ClassMethods
        attribute :custom_data, ::Shale::Type::Value, default: -> { ::Hash.new } # rubocop:disable Style/EmptyLiteral
      end

      # Class methods for models with custom data.
      module ClassMethods
        # @return [Boolean] Whether this object supports custom data.
        def custom_data_supported?
          true
        end
      end
    end
  end
end

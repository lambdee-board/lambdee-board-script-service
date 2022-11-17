# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for handling custom user data
    # in DB records.
    module CustomData
      extend ::ActiveSupport::Concern

      included do
        attribute :custom_data, ::Shale::Type::Value, default: -> { ::Hash.new } # rubocop:disable Style/EmptyLiteral
      end

      # @return [Boolean] Whether this object supports custom data.
      def custom_data?
        true
      end
    end
  end
end

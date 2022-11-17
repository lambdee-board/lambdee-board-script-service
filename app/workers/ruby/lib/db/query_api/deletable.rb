# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for deleting records.
    module Deletable
      extend ::ActiveSupport::Concern

      # @!attribute [rw] deleted_at
      #   @return [Time] When the record was deleted.
      included do
        attribute :deleted_at, ::Shale::Type::Time
      end

      # @return [Boolean] Whether the record has been deleted.
      def deleted?
        !deleted_at.nil?
      end
    end
  end
end

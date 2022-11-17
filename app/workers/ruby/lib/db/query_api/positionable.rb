# frozen_string_literal: true

module DB
  module QueryAPI
    # Provides methods for positioning records.
    module Positionable
      extend ::ActiveSupport::Concern

      # @!attribute [rw] pos
      #   @return [Float] Floating point value
      #     which determines the position of this record.
      included do
        attribute :pos, ::Shale::Type::Float
      end

      # @return [Float] Floating point value
      #   which determines the position of this record.
      def position
        pos
      end

      # @param val [Float] Floating point value
      #   which determines the position of this record.
      def position=(val)
        self.pos = val
      end
    end
  end
end

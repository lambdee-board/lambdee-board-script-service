# frozen_string_literal: true

require 'refrigerator'

# Freezes almost all constants in this Ruby process.
module ConstantFreezer
  LEFT_MODULES = ::Set[::ENV, ::Digest, ::Object, ::Gem]

  class << self
    # @return [void]
    def call
      ::Refrigerator.freeze_core(except: %w[Object])
      freeze_all_constants
    end

    private

    # @param mod [Module, Class]
    # @return [void]
    def freeze_all_constants(mod = ::Object)
      return if mod.frozen?
      return if LEFT_MODULES.include?(mod) && mod != ::Object

      mod.constants.each do |constant|
        value = mod.const_get(constant)
        # puts "#{mod} - #{value}"

        value.freeze unless ::Set[::IO, ::Binding].include?(value.class) || LEFT_MODULES.include?(value)
        freeze_all_constants(value) if value.is_a?(::Module) && mod != value
      end
    end
  end
end

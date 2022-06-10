# frozen_string_literal: true

require './app/app'

run ::App

# freeze all modules and classes from stdlib
require 'refrigerator'
::Refrigerator.freeze_core(except: %w[Object])


# freeze all constants

LEFT_MODULES = ::Set[::ENV, ::Rack, ::Digest, ::App, ::Object, ::Gem]
# @param mod [Module]
# @return [void]
def freeze_all_constants(mod = ::Object)
  return if mod.frozen?
  return if LEFT_MODULES.include? mod

  mod.constants.each do |constant|
    value = mod.const_get(constant)
    puts "#{mod} - #{value}"
    unless ::Set[::IO, ::Binding].include?(value.class) || LEFT_MODULES.include?(value)
      value.freeze
    end
    freeze_all_constants(value) if value.is_a?(::Module) && mod != value
  end
end

freeze_all_constants

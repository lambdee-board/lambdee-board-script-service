# frozen_string_literal: true

require_relative 'censor'

using ::Censor::Refinement

# rubocop:disable Style/TopLevelMethodDefinition

# @return [Binding]
define_method :__safe_binding__ do
  safe_binding = nil
  ::Module.new do
    extend self

    # @return [String]
    def inspect = 'main'
    attr_accessor :context

    self.context = ::ActiveSupport::HashWithIndifferentAccess.new
    safe_binding = binding
  end

  safe_binding
end

# rubocop:enable Style/TopLevelMethodDefinition

# frozen_string_literal: true

require_relative 'censor'

using ::Censor::Refinement

# rubocop:disable Style/TopLevelMethodDefinition

# @return [Binding]
def __safe_binding__
  safe_binding = nil
  ::Module.new do
    extend self

    safe_binding = binding
  end

  safe_binding
end

# rubocop:enable Style/TopLevelMethodDefinition

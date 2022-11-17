# frozen_string_literal: true

# Provides methods for converting the object to a Hash.
module HashConvertible
  # @return [Hash]
  def to_h(_options = {})
    result = {}
    instance_variables.each do |ivar|
      result[ivar.to_s[1..].to_sym] = instance_variable_get(ivar)
    end
    result
  end
  alias to_hash to_h
end

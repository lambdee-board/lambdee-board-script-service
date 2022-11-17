# frozen_string_literal: true

require_relative 'awesome_print'

# Provides getters and setters by calling `#[]` and `#[]=`.
module HashLikeAccess
  # @param key [Symbol, String]]
  # @return [Object]
  def [](key)
    return unless respond_to?(key)

    public_send(key)
  end

  # @param key [Symbol, String]
  # @param val [Object]
  def []=(key, val)
    public_send(:"#{key}=", val)
  end

  # # @return [Hash]
  # def to_h(_options = {})
  #   result = {}
  #   instance_variables.each do |ivar|
  #     result[ivar.to_s[1..].to_sym] = instance_variable_get(ivar)
  #   end
  #   result
  # end
  # alias to_hash to_h

  # @return [String]
  def inspect
    "#{self.class}#{to_h.ai}"
  end
end

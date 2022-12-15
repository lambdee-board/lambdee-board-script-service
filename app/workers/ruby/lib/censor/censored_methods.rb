# frozen_string_literal: true

module Censor
  # Object which encapsulates Modules/Classes with
  # the names of their methods that should be censored
  # when running scripts.
  class CensoredMethods
    # @return [Module, Class, Object]
    attr_reader :mod
    # @return [Class]
    attr_reader :singleton_class
    # @return [Array<Symbol>] censored instance methods
    attr_reader :instance
    # @return [Array<Symbol>] censored singleton methods
    attr_reader :singleton

    # @param mod [Module, Class]
    # @param instance [Array<Symbol>]
    # @param singleton [Array<Symbol>]
    def initialize(mod, instance: [], singleton: [])
      @singleton_class = mod.singleton_class

      unless mod.is_a?(::Module)
        @singleton = singleton.empty? ? mod.singleton_methods : singleton
        return
      end

      if instance.empty? && singleton.empty?
        instance = mod.instance_methods(false)
        singleton = mod.singleton_methods
      end

      @mod = mod
      @instance = instance
      @singleton = singleton
    end
  end
end

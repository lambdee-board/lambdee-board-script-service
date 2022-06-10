# frozen_string_literal: true

module Console
  module Censor
    # Object which encapsulates Modules/Classes with
    # the names of their methods that should be censored
    # when running scripts.
    class CensoredMethods
      class << self
        def [](...)
          new(...)
        end
      end

      # @return [Module, Class]
      attr_reader :mod
      # @return [Array<Symbol>] censored instance methods
      attr_reader :instance
      # @return [Array<Symbol>] censored singleton methods
      attr_reader :singleton

      # @param mod [Module, Class]
      # @param :instance [Array<Symbol>, S]
      # @param :singleton [Array<Symbol>]
      def initialize(mod, instance: [], singleton: [])
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
end

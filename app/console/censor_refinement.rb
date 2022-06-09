# frozen_string_literal: true

module Console
  # Censors modules/classes by overriding all of their methods
  # (both instance and singleton/class methods)
  #
  # This overriding is only temporary and in effect in the scope
  # in which this module was passed to the `using` method.
  #
  #     Thread.new { puts :hello } #=> hello
  #     File.read('some_file') #=> "file content"
  #
  #     using CensorRefinement
  #
  #     Thread.new { puts :hello } #=> :censored_method
  #     File.read('some_file') #=> :censored_method
  #
  module CensorRefinement
    # @return [Array<Module>] Modules/Classes that will be censored/blocked
    CENSORED_MODULES = [
      ::Thread,
      ::Fiber,
      ::File,
      ::Dir,
      ::FileUtils,
      ::Ractor,
      ::RubyVM,
      ::Binding,
      ::ThreadGroup,
    ].freeze

    class << self
      # @param censored_mod [Class, Module]
      # @return [Module]
      def censored_instance_methods_module(censored_mod)
        ::Module.new do
          # SIC!
          # This seems stupid, I know. I'm evaluating a dynamic string
          # rather than using `define_method`, because **Refinements**
          # can only import methods defined with Ruby code.
          # Hence, classical metaprogramming doesn't work.
          #
          # Interestingly enough, evaluating a string
          # creates same methods as regular ones defined in code.
          current_binding = binding
          censored_mod.instance_methods(false).each do |m|
            eval <<~RUBY, current_binding
              def #{m}(*, **, &)
                :censored_method
              end
            RUBY
          end
        end
      end

      # @param censored_mod [Class, Module]
      # @return [Module]
      def censored_singleton_methods_module(censored_mod)
        ::Module.new do
          current_binding = binding

          censored_mod.singleton_methods.each do |m|
            eval <<~RUBY, current_binding
              def #{m}(*, **, &)
                :censored_method
              end
            RUBY
          end

          def new
            :censored_method
          end
        end
      end

      # @param mod [Module]
      def censor_module(mod)
        this = self

        # override instance methods
        refine mod do
          import_methods this.censored_instance_methods_module(mod)
        end

        # override singleton/class methods
        refine mod.singleton_class do
          import_methods this.censored_singleton_methods_module(mod)
        end
      end
    end

    CENSORED_MODULES.each do |mod|
      censor_module(mod)
    end
  end
end

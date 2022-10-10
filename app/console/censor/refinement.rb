# frozen_string_literal: true

require 'logger'

# Internal Ruby module used for printing warnings.
# Ruby warnings like constant reassigning will now raise errors.
module Warning
  # @param message [String]
  # @return [void]
  def warn(message)
    raise ::StandardError, message
  end
end

::Warning.freeze

module Console
  module Censor
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
    module Refinement
      # @return [Array<Module, Class>] Modules/Classes that will be censored/blocked
      CENSORED_MODULES = [
        self,
        ::Thread,
        ::Fiber,
        ::File,
        ::Dir,
        ::FileUtils,
        ::Ractor,
        ::RubyVM,
        ::Binding,
        ::ThreadGroup,
        ::TracePoint,
        ::Logger
      ].freeze

      # @return [Array<Symbol>] Kernel methods that will be censored/blocked
      CENSORED_KERNEL_METHODS = %i[
        fork
        spawn
        eval
        system
        __callee__
        __dir__
        __method__
        at_exit
        autoload
        autoload?
        callcc
        caller
        caller_locations
        exec
        exit
        exit!
        load
        open
        require
        require_relative
        select
        set_trace_func
        syscall
        test
        trace_var
        untrace_var
        trap
        pp
        `
      ].freeze

      # @return [Array<CensoredMethods>]
      CENSORED_METHODS = [
        *CENSORED_MODULES.map { CensoredMethods.new(_1) },
        CensoredMethods.new(
          ::Kernel,
          instance: CENSORED_KERNEL_METHODS,
          singleton: CENSORED_KERNEL_METHODS
        ),
        CensoredMethods.new(
          ::Module,
          instance: %i[
            autoload
            autoload?
            deprecate_constant
            remove_method
            undef_method
            remove_class_variable
            remove_const
          ]
        )
      ].freeze

      class << self
        # rubocop:disable Security/Eval

        # @param censored_methods [CensoredMethods]
        # @param type [Symbol]
        # @return [Module]
        def censored_methods_module(censored_methods, type:)
          ::Module.new do
            current_binding = binding
            censored_methods.public_send(type).each do |m|
              eval <<~RUBY, current_binding, __FILE__, __LINE__ + 1
                def #{m}(*, **, &)
                  :censored_method
                end
              RUBY
            end
          end

          # rubocop:enable Security/Eval
        end

        # @param censored_methods [CensoredMethods]
        def censor_module(censored_methods)
          this = self

          # override instance methods
          refine censored_methods.mod do
            import_methods this.censored_methods_module(censored_methods, type: :instance)
          end

          # override singleton/class methods
          refine censored_methods.mod.singleton_class do
            import_methods this.censored_methods_module(censored_methods, type: :singleton)
          end
        end
      end

      CENSORED_METHODS.each do |censored_methods_object|
        censor_module(censored_methods_object)
      end

      freeze
    end
  end
end

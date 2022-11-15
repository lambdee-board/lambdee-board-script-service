# frozen_string_literal: true

require 'stringio'
require 'timeout'

require_relative 'string_input_method'
require_relative '../safe_binding'

module Console
  # Creates an IRB session and provides methods
  # for executing Ruby code in it.
  class Session
    # Max amount of seconds code should be evaluated
    #
    # @return [Integer]
    EXECUTION_TIMEOUT = 5

    # Create a new IRB session
    def initialize
      @input_method = StringInputMethod.new

      workspace = ::IRB::WorkSpace.new(__safe_binding__)
      @irb = ::IRB::Irb.new(workspace, @input_method)
    end

    # @param string [String] Ruby code
    # @return [void]
    def evaluate(string, stdout)
      @input_method.puts string
      orig_stdout = $stdout
      $stdout = stdout
      begin
        ::Timeout.timeout(EXECUTION_TIMEOUT) do
          @irb.eval_input # evaluate code
        end
      rescue ::Timeout::Error => e
        puts "#{e.message} (#{e.class})\n"
      end
      $stdout = orig_stdout
    end
  end
end

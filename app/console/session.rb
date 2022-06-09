# frozen_string_literal: true

require 'stringio'
require 'timeout'

def __anonymous_binding__
  anonymous_binding = nil
  Module.new do
    extend self
    anonymous_binding = binding
  end

  anonymous_binding
end

module Console
  class Session
    # @return [Integer] Max amount of characters of the evaluated code's output
    OUTPUT_MAX_CHARACTERS = 5_000
    # @return [Integer] Max amount of lines of the evaluated code's output
    OUTPUT_MAX_LINES = 200
    # @return [Integer] Max amount of seconds code should be evaluated
    EXECUTION_TIMEOUT = 20

    def initialize
      @input_method = StringInputMethod.new

      workspace = ::IRB::WorkSpace.new(__anonymous_binding__)
      @irb = ::IRB::Irb.new(workspace, @input_method)
    end

    # @param string [String] Ruby code
    # @return [String] IRB output
    def evaluate(string)
      @input_method.puts string
      io = ::StringIO.new
      orig_stdout = $stdout
      $stdout = io
      timeout_error = nil
      begin
        ::Timeout.timeout(EXECUTION_TIMEOUT) do
          @irb.eval_input # evaluate code
        end
      rescue ::Timeout::Error => e
        timeout_error = e
      end
      $stdout = orig_stdout

      sanitize_output(io.string, timeout_error)
    end

    private

    # @param output [String]
    # @param error [StandardError, nil]
    # @return [String]
    def sanitize_output(output, error = nil)
      sliced = false

      if output.length > OUTPUT_MAX_CHARACTERS
        output = output[...OUTPUT_MAX_CHARACTERS]
        sliced = true
      end

      output = output.lines

      if output.length > OUTPUT_MAX_LINES
        output = output[...OUTPUT_MAX_LINES]
        sliced = true
      end

      output << "\n"
      output << "#{error.message} (#{error.class})\n" if error
      output << "Output has been sliced because it was too long\n" if sliced
      puts output
      output.reject { |line| line.start_with?(LAMBDEE_PROMPT) }.join
    end
  end
end

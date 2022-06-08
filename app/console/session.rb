# frozen_string_literal: true

require 'stringio'

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
    # attr_reader :input_method, :irb

    def initialize
      @input_method = StringInputMethod.new

      workspace = ::IRB::WorkSpace.new(__anonymous_binding__)
      @irb = ::IRB::Irb.new(workspace, @input_method)
    end

    # @param string [String] Ruby code
    # @return [String] IRB output
    def evaluate(string)
      @input_method.puts string
      p @input_method.exps
      io = ::StringIO.new
      orig_stdout = $stdout
      $stdout = io
      @irb.eval_input # evaluate code
      $stdout = orig_stdout

      io.string.lines.reject { |line| line.start_with?(LAMBDEE_PROMPT) }.join
    end
  end
end

require 'irb'
require 'irb/xmp'
require 'stringio'

require 'debug'

# debugger
IRB.conf[:BACK_TRACE_LIMIT] = 5
IRB.conf[:VERBOSE] = true
IRB.conf[:INSPECT_MODE] = true
# IRB.conf[:ECHO] = false
IRB.conf[:LC_MESSAGES] = IRB::Locale.new
IRB.conf[:SINGLE_IRB] = true
IRB.conf[:PROMPT_MODE] = :lambdee
IRB.conf[:IRB_NAME] = 'lambdee'
IRB.conf[:PROMPT] = {
  lambdee: { PROMPT_I: '%N:%03n:%i> ',
             PROMPT_N: '%N:%03n:%i? ',
             PROMPT_S: '%N:%03n:%i%l ',
             PROMPT_C: '%N:%03n:%i* ',
             RETURN: "=> %s\n" }
}

module LambdeeConsole
  class StringInputMethod < XMP::StringInputMethod
    def gets
      while (l = @exps.shift)
        next if /^\s+$/ =~ l

        l.concat "\n"
        print @prompt
        break
      end
      l
    end
  end
end

input_method = LambdeeConsole::StringInputMethod.new

anonymous_binding = nil
Module.new do
  extend self
  anonymous_binding = binding
end

workspace = IRB::WorkSpace.new(anonymous_binding)
irb = IRB::Irb.new(workspace, input_method)

input_method.puts <<~RUBY
  def dupa
    :cipa
  end
RUBY

input_method.puts 'p dupa'

io = StringIO.new
orig_stdout = $stdout
$stdout = io
irb.eval_input # evaluate code
$stdout = orig_stdout

puts io.string
# debugger

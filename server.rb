require 'rubygems'
require 'bundler'
::Bundler.require(:default) # load gems from the gemfile
require 'debug'

require 'irb'
require 'irb/xmp'
require 'stringio'

IRB.conf[:BACK_TRACE_LIMIT] = 5
IRB.conf[:VERBOSE] = true
IRB.conf[:INSPECT_MODE] = true
IRB.conf[:ECHO] = true
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

def anonymous_binding
  anonymous_binding = nil
  Module.new do
    extend self
    anonymous_binding = binding
  end
end

module LambdeeConsole
  class Session
    # attr_reader :input_method, :irb

    def initialize
      @input_method = StringInputMethod.new

      workspace = IRB::WorkSpace.new(anonymous_binding)
      @irb = IRB::Irb.new(workspace, @input_method)
    end

    # @param string [String] Ruby code
    # @return [String] IRB output
    def evaluate(string)
      @input_method.puts string
      io = StringIO.new
      orig_stdout = $stdout
      $stdout = io
      @irb.eval_input # evaluate code
      $stdout = orig_stdout

      io.string
    end
  end

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

EventMachine.run do
  EventMachine::WebSocket.run(host: '0.0.0.0', port: 8080, debug: false) do |ws|
    ws.onopen do |handshake|
      puts "WebSocket opened #{{
        path: handshake.path,
        query: handshake.query,
        origin: handshake.origin
      }}"

      ws.send 'Hello Client!'

      session = LambdeeConsole::Session.new

      ws.onmessage do |msg|
        output = session.evaluate msg
        puts output
        ws.send output.gsub(/\e\[(\d*)m/, '') # remove terminal formatting
      end

      ws.onclose do
        puts 'WebSocket closed'
      end
    end

    ws.onerror do |e|
      puts "Error: #{e.message}"
    end
  end
end

# debugger

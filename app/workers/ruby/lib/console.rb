# frozen_string_literal: true

require 'irb'
require 'sorted_set'

require_relative 'awesome_print'

# Contains code which handles the web console.
# It can execute arbitrary Ruby code while censoring
# dangerous classes/modules, forbidding constant reassignment
# and freezing important constants (stdlib modules/classes).
module Console
  # @return [String]
  RETURN_PROMPT = '  => '
  LAMBDEE_PROMPT = '<<<LMBD_PROMPT>>> '
end

# Configure a replacement for the default `inspect` used in IRB.
::IRB::Irb.class_eval do
  # override how IRB prints returned values
  def output_value(*)
    puts "#{::Console::RETURN_PROMPT}#{@context.last_value.ai}"
  rescue NoMethodError
    puts("#{::Console::RETURN_PROMPT}#{@context.last_value.inspect}") || return if @context.last_value.respond_to?(:inspect)

    puts "#{::Console::RETURN_PROMPT}(Object doesn't support #ai)"
  end
end

# Configure IRB for embedded use.
IRB.conf[:BACK_TRACE_LIMIT] = 0
IRB.conf[:VERBOSE] = false
IRB.conf[:INSPECT_MODE] = true
# IRB.conf[:CONTEXT_MODE] = 1
IRB.conf[:ECHO] = true
IRB.conf[:LC_MESSAGES] = ::IRB::Locale.new
IRB.conf[:SINGLE_IRB] = false
IRB.conf[:USE_TRACER] = false
IRB.conf[:USE_COLORIZE] = true
IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:PROMPT_MODE] = :lambdee
IRB.conf[:IRB_NAME] = 'lambdee'
IRB.conf[:COMMAND_ALIASES] = { '$': :show_source, '@': :whereami, break: :irb_break, catch: :irb_catch, next: :irb_next }
IRB.conf[:PROMPT] = {
  lambdee: {
    PROMPT_I: ::Console::LAMBDEE_PROMPT,
    PROMPT_N: ::Console::LAMBDEE_PROMPT,
    PROMPT_S: ::Console::LAMBDEE_PROMPT,
    PROMPT_C: ::Console::LAMBDEE_PROMPT,
    RETURN: "=> %s\n"
  }
}

require_relative 'console/string_input_method'
require_relative 'console/session'

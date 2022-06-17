# frozen_string_literal: true

require 'irb'
require 'awesome_print'
require 'sorted_set'

# Contains code which handles the web console.
# It can execute arbitrary Ruby code while censoring
# dangerous classes/modules, forbidding constant reassignment
# and freezing important constants (stdlib modules/classes).
module Console
  # @return [String]
  RETURN_PROMPT = '  => '
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

::AwesomePrint.defaults = {
  indent: 2, # Number of spaces for indenting.
  index: true, # Display array indices.
  html: false, # Use ANSI color codes rather than HTML.
  multiline: true, # Display in multiple lines.
  plain: true, # Use colors.
  raw: false,  # Do not recursively format instance variables.
  sort_keys: false,  # Do not sort hash keys.
  sort_vars: true,   # Sort instance variables.
  limit: false, # Limit arrays & hashes. Accepts bool or int.
  ruby19_syntax: true, # Use Ruby 1.9 hash syntax in output.
  class_name: :class, # Method called to report the instance class name. (e.g. :to_s)
  object_id: true # Show object id.
}

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
LAMBDEE_PROMPT = '<<<LMBD_PROMPT>>> '
IRB.conf[:PROMPT] = {
  lambdee: {
    PROMPT_I: LAMBDEE_PROMPT,
    PROMPT_N: LAMBDEE_PROMPT,
    PROMPT_S: LAMBDEE_PROMPT,
    PROMPT_C: LAMBDEE_PROMPT,
    RETURN: "=> %s\n"
  }
}

require_relative 'console/string_input_method'
require_relative 'console/censor'
require_relative 'console/session'

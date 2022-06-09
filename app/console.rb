require 'irb'
require 'awesome_print'

module Console; end

AwesomePrint.irb!

AwesomePrint.defaults = {
  indent: 2,      # Number of spaces for indenting.
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
  object_id: true   # Show object id.
}

IRB.conf[:BACK_TRACE_LIMIT] = 0
IRB.conf[:VERBOSE] = true
IRB.conf[:INSPECT_MODE] = true
IRB.conf[:ECHO] = true
IRB.conf[:LC_MESSAGES] = ::IRB::Locale.new
IRB.conf[:SINGLE_IRB] = true
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
require_relative 'console/censor_refinement'
require_relative 'console/session'

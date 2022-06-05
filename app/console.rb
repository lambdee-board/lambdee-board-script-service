require 'irb'

module Console; end

IRB.conf[:BACK_TRACE_LIMIT] = 0
IRB.conf[:VERBOSE] = true
IRB.conf[:INSPECT_MODE] = true
IRB.conf[:ECHO] = true
IRB.conf[:LC_MESSAGES] = ::IRB::Locale.new
IRB.conf[:SINGLE_IRB] = true
IRB.conf[:USE_TRACER] = false
IRB.conf[:USE_AUTOCOMPLETE] = false
IRB.conf[:PROMPT_MODE] = :lambdee
IRB.conf[:IRB_NAME] = 'lambdee'
IRB.conf[:PROMPT] = {
  lambdee: { PROMPT_I: '%N:%03n:%i> ',
             PROMPT_N: '%N:%03n:%i? ',
             PROMPT_S: '%N:%03n:%i%l ',
             PROMPT_C: '%N:%03n:%i* ',
             RETURN: "=> %s\n" }
}

require_relative 'console/string_input_method'
require_relative 'console/session'

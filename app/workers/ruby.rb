# frozen_string_literal: true

# Contains all classes and scripts which handle
# separate Ruby worker processes which execute
# Ruby code.
module Workers::Ruby; end

require_relative 'ruby/repl'
require_relative 'ruby/script'

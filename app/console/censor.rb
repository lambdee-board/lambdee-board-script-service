# frozen_string_literal: true

module Console
  # Module containing code which censors/blocks
  # some parts of the Ruby language to make
  # executing user provided code safer.
  module Censor; end
end

require_relative 'censor/censored_methods'
require_relative 'censor/refinement'

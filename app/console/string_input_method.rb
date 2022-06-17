# frozen_string_literal: true

require 'irb/xmp'

module Console
  # Custom input method for IRB which
  # enables it to consume `String` input.
  class StringInputMethod < ::XMP::StringInputMethod
    # @return [Array<String>]
    attr_reader :exps

    # @return [String]
    def gets
      result = @exps.grep_v(/^\s*$/).join(';')
      @exps.clear
      return if result.empty?

      print @prompt
      result.concat("\n")
    end
  end
end

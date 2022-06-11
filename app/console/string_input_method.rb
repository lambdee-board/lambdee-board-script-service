# frozen_string_literal: true

require 'irb/xmp'

module Console
  # Custom input method for IRB which
  # enables it to consume `String` input.
  class StringInputMethod < ::XMP::StringInputMethod
    attr_reader :exps

    def gets
      result = @exps.reject { /^\s*$/ =~ _1 }.join(';')
      @exps.clear
      return if result.empty?

      print @prompt
      result.concat("\n")
    end
  end
end

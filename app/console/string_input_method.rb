# frozen_string_literal: true

require 'irb/xmp'

module Console
  class StringInputMethod < XMP::StringInputMethod
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

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
      return if @exps.nil? || @exps.empty?

      result = @exps.join("\n")
      @exps.clear
      return if result.empty?

      print @prompt
      result.concat("\n")
    end
  end
end

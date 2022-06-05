# frozen_string_literal: true

require 'irb/xmp'

module Console
  class StringInputMethod < XMP::StringInputMethod
    def gets
      while (l = @exps.shift)
        next if /^\s+$/ =~ l

        l.concat "\n"
        print @prompt
        break
      end
      l
    end
  end
end

require 'irb'
require 'irb/xmp'
require 'stringio'

require 'debug'

input_method = XMP::StringInputMethod.new

# `input_method.gets` prints and returns a line!

anonymous_binding = nil
Module.new do
  extend self
  anonymous_binding = binding
end

irb = XMP.new anonymous_binding

# io = StringIO.new
# orig_stdout = $stdout
# $stdout = io

irb.puts <<~RUBY
  def dupa
    :cipa
  end
RUBY

irb.puts 'p dupa'

# $stdout = orig_stdout

# puts io.string
# debugger

# frozen_string_literal: true

require 'socket'
require 'logger'
require 'debug' unless %w[production test].include? ::ENV['RACK_ENV']

# from the shared library with the Sinatra app
require_relative '../../../utils'
require_relative '../../../unix_socket'

# from the library for scripts
require_relative '../lib/script_stdlib'
require_relative '../lib/console'
require_relative '../lib/constant_freezer'

# @return [Logger]
::LOGGER =
  if %w[production test].include? ::Config::RACK_ENV
    ::Logger.new(
      ::File.expand_path('../../../../log/ruby_repl.log', __dir__),
      4,
      level: ::Logger::INFO
    )
  else
    ::Logger.new(
      $stdout,
      level: ::Logger::DEBUG
    )
  end

::Utils.format_logger(::LOGGER)

at_exit { ::LOGGER.info 'dying' }

# Catch the Interrupt signal and gracefully exit
::Signal.trap('INT') do
  exit
end

::LOGGER.info 'starting unix socket server'

::Censor.override_dangerous_things

::CONSOLE_SESSION = ::Console::Session.new

::ConstantFreezer.call

::Socket.unix_server_loop(::UnixSocket.repl_worker_path(::Process.pid)) do |socket, _client|
  connection = ::UnixSocket::Connection.new(socket)
  socket_out = ::UnixSocket::Stdout.new(connection)
  ::LOGGER.info 'unix socket server started'

  loop do
    message = connection.read
    next if message.nil?
    next unless message.type == :input

    ::CONSOLE_SESSION.evaluate message.payload, socket_out
    connection.write(type: :output_end)
  end
ensure
  connection&.close
end

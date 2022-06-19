# frozen_string_literal: true

require 'debug'

require 'socket'
require 'logger'
require 'digest'

require_relative '../../unix_socket'
require_relative '../../console'
require_relative '../../utils'
require_relative '../../constant_freezer'

# @return [Logger]
::LOGGER = ::Logger.new($stdout)
::LOGGER.level = ::Logger::DEBUG
::Utils.format_logger(::LOGGER)

at_exit { ::LOGGER.info 'dying' }

# Catch the Interrupt signal and gracefully exit
::Signal.trap('INT') do
  exit
end

::LOGGER.info 'starting unix socket server'

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

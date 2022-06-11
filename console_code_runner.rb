# frozen_string_literal: true

require 'socket'
require 'logger'

require_relative 'app/unix_socket'
require_relative 'app/console'
require_relative 'app/utils'

# @return [Logger]
::LOGGER = ::Logger.new($stdout)
::LOGGER.level = ::Logger::DEBUG
::Utils.format_logger(::LOGGER)

at_exit { ::LOGGER.info 'dying' }
::Signal.trap('INT') do
  exit
end

::LOGGER.info 'starting unix socket server'

CONSOLE_SESSION = ::Console::Session.new

::Socket.unix_server_loop(::UnixSocket.code_runner_path(::Process.pid)) do |socket, _client|
  connection = ::UnixSocket::Connection.new(socket)
  ::LOGGER.info 'unix socket server started'
  loop do
    message = connection.read
    next unless message[:type] == :input

    output = CONSOLE_SESSION.evaluate message[:payload]
    connection.write({ type: :output,
                       payload: output })
  end
ensure
  connection.close
end

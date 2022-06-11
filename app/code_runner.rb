# frozen_string_literal: true

require 'timeout'

class CodeRunner
  # @return [String]
  START_SCRIPT_PATH = 'console_code_runner.rb'

  # Opens a new process of a code runner and
  # establishes a UNIX Socket connection with it.
  #
  # You should call the `#close` method once
  # you're done with this code runner, otherwise
  # the process and Socket will linger.
  def initialize
    @closed = false
    @pid = spawn(::RbConfig.ruby, START_SCRIPT_PATH)
    ::Process.detach(@pid)
    socket_path = ::UnixSocket.code_runner_path(@pid)
    ::Timeout.timeout(5) do
      until ::File.exist?(socket_path); end
    end
    @connection = ::UnixSocket::Connection.open(socket_path)
  rescue ::UnixSocket::Connection::Error, ::Timeout::Error
    close
  end

  # @return [Integer]
  attr_reader :pid

  # @return [UnixSocket::Connection]
  attr_reader :connection

  # @return [Boolean]
  attr_reader :closed

  alias closed? closed

  # Closes the worker process and the UNIX socket.
  #
  # @return [void]
  def close
    begin
      Process.kill('INT', @pid)
    rescue ::Errno::ESRCH
    end
    @connection&.close
    ::LOGGER.info "killing worker #{@pid}"
    @closed = true
  end
end

# frozen_string_literal: true

require 'timeout'

require_relative '../../unix_socket'

# Represents a single REPL worker -- a separate process
# which can securely execute Ruby code and which retains its state
# throughout calls.
#
# Communication with this process is based on UNIX Sockets.
class Workers::Ruby::REPL
  # @return [String]
  START_SCRIPT_PATH = ::File.expand_path('repl/script.rb', __dir__)
  # Max time in seconds of how long the class should try to
  # connect to the worker process through a UNIX Socket.
  #
  # @return [Integer]
  SOCKET_CONNECTION_TIMEOUT = 5

  # Opens a new process of a repl worker and
  # establishes a UNIX Socket connection with it.
  #
  # You should call the `#close` method once
  # you're done with this repl worker, otherwise
  # the process and Socket will linger.
  def initialize
    @closed = false
    @pid = spawn(::RbConfig.ruby, START_SCRIPT_PATH)
    ::Process.detach(@pid)
    ::LOGGER.info "spawned Ruby repl-worker #{@pid}"
    socket_path = ::UnixSocket.repl_worker_path(@pid)

    ::Timeout.timeout(SOCKET_CONNECTION_TIMEOUT) do
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

  # rubocop:disable Lint/SuppressedException

  # Closes the worker process and the UNIX socket.
  #
  # @return [void]
  def close
    begin
      ::Process.kill('INT', @pid)
    rescue ::Errno::ESRCH # No such process
    end
    @connection&.close
    ::LOGGER.info "killing Ruby repl-worker #{@pid}"
    @closed = true
  end
  # rubocop:enable Lint/SuppressedException
end

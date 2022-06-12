# frozen_string_literal: true

# Contains code for communicating
# between processes via UNIX Sockets
module UnixSocket
  class << self
    # Path to the Socket file of a particular REPL worker.
    #
    # @param pid [Integer] Process ID of the REPL worker.
    # @return [String]
    def repl_worker_path(pid)
      "/tmp/lambdee-repl-worker-#{pid}.sock"
    end
  end
end

require_relative 'unix_socket/message'
require_relative 'unix_socket/connection'

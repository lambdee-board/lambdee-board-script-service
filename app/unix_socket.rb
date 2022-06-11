# frozen_string_literal: true

# Contains code for communicating
# between processes via UNIX Sockets
module UnixSocket
  class << self
    # Path to the Socket file of a particular code runner.
    #
    # @param pid [Integer] Process ID of the code runner.
    # @return [String]
    def code_runner_path(pid)
      "/tmp/lambdee-code-runner-#{pid}.sock"
    end
  end
end

require_relative 'unix_socket/message'
require_relative 'unix_socket/connection'

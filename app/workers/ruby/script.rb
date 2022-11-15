# frozen_string_literal: true

# Represents a single Script worker -- a separate process
# which securely executes Ruby code and returns its output.
class Workers::Ruby::Script
  # @return [String]
  RUN_FILE_PATH = ::File.expand_path('script/run.rb', __dir__)
  # Max time in seconds of how long the class should try to
  # connect to the worker process through a UNIX Socket.
  #
  # @return [Integer]
  SOCKET_CONNECTION_TIMEOUT = 5

  class << self
    # @param code [String]
    # @param script_run_id [Integer]
    def execute(code, script_run_id)
      pid = spawn(::RbConfig.ruby, RUN_FILE_PATH, code.to_s, script_run_id.to_s)
      ::Process.detach(pid)
      ::LOGGER.info "spawned Ruby script-worker #{pid}"
    end
  end
end

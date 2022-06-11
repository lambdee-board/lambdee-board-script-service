# frozen_string_literal: true

# General utility functions.
module Utils
  extend self

  # @param logger [Logger]
  # @return [void]
  def format_logger(logger)
    logger.formatter = proc do |severity, date, _prog_name, msg|
      date_format = date.strftime('%Y-%m-%d %H:%M:%S')
      "[#{date_format}] #{severity.rjust(6, ' ')}  (PID:#{Process.pid}): #{msg}\n"
    end
  end
end

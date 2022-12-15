# frozen_string_literal: true

require 'active_support/all'
require 'logger'
require 'stringio'
require 'debug' unless %w[production test].include? ::ENV['RACK_ENV']

# from the shared library with the Sinatra app
require_relative '../../../utils'

# from the library for scripts
require_relative '../lib/db'
require_relative '../lib/safe_binding'
require_relative '../lib/constant_freezer'

# @return [Logger]
::LOGGER =
  if %w[production test].include? ::Config::RACK_ENV
    ::Logger.new(
      ::File.expand_path('../../../../log/ruby_script.log', __dir__),
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

::LOGGER.info 'starting script execution'

::Censor.override_dangerous_things

code, script_run_id = ::ARGV
code = <<~RUBY
  lambda do
    #{code}
  end.call
RUBY

script_state = :executed

output = ::StringIO.new
$stdout = output
begin
  ::Timeout.timeout(::Config::SCRIPT_EXECUTION_TIMEOUT, nil, "execution took longer than allowed #{::Config::SCRIPT_EXECUTION_TIMEOUT} seconds") do
    eval code, __safe_binding__, '(script)' # rubocop:disable Security/Eval
  end
rescue ::Timeout::Error => e
  puts e.full_message
  script_state = :timed_out
rescue ::Exception => e # rubocop:disable Lint/RescueException
  puts e.full_message
  script_state = :failed
end

$stdout = ::STDOUT # rubocop:disable Style/GlobalStdStream
::LOGGER.debug "Script Output:\n#{output.string}" unless %w[production test].include? ::ENV['RACK_ENV']

::LambdeeAPI.http_connection.patch("script_runs/#{script_run_id}") do |req|
  req.body = {
    output: output.string,
    state: script_state
  }.to_json
end

# frozen_string_literal: true

require 'active_support'
require 'socket'
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
  if %w[production test].include? ::ENV['RACK_ENV']
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

output = ::StringIO.new
$stdout = output
code, script_run_id = ::ARGV
begin
  ::Timeout.timeout(::Config::SCRIPT_EXECUTION_TIMEOUT) do
    eval code, __safe_binding__, '(script)' # rubocop:disable Security/Eval
  end
rescue ::Timeout::Error => e
  puts e.full_message
rescue ::Exception => e # rubocop:disable Lint/RescueException, Lint/DuplicateBranch
  puts e.full_message
end

$stdout = ::STDOUT # rubocop:disable Style/GlobalStdStream
::LOGGER.debug output.string unless %w[production test].include? ::ENV['RACK_ENV']

::LambdeeAPI.http_connection.patch("script_runs/#{script_run_id}") do |req|
  req.body = { output: output.string }.to_json
end
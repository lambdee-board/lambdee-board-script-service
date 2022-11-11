# frozen_string_literal: true

require 'logger'

require_relative './app/utils'

::LOGGER =
  if %w[production test].include? ::ENV['RACK_ENV']
    ::Logger.new(
      ::File.expand_path('./log/sinatra.log', __dir__),
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

require './app/controllers'

run ::Controllers::App

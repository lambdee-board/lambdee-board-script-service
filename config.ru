# frozen_string_literal: true

require 'logger'

require_relative './app/utils'

::LOGGER = ::Logger.new($stdout)
::LOGGER.level = if %w[production test].include? ENV['RACK_ENV']
                   ::Logger::INFO
                 else
                   ::Logger::DEBUG
                 end
::Utils.format_logger(::LOGGER)

require './app/controllers'

run ::Controllers::App

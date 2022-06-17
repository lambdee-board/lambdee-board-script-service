# frozen_string_literal: true

require 'logger'
require 'debug'

require_relative './app/utils'

::LOGGER = ::Logger.new($stdout)
::LOGGER.level = ::Logger::DEBUG
::Utils.format_logger(::LOGGER)

require './app/controllers'

run ::Controllers::App

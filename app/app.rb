# frozen_string_literal: true

require 'sinatra/base'
require 'logger'

require_relative 'utils'
require_relative 'unix_socket'
require_relative 'web_socket'
require_relative 'code_runner'

::LOGGER = ::Logger.new($stdout)
::LOGGER.level = ::Logger::DEBUG
::Utils.format_logger(::LOGGER)

class App < ::Sinatra::Base
  use ::WebSocket::Middleware

  get '/' do
    'Hello World'
  end
end

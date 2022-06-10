# frozen_string_literal: true

require 'sinatra/base'
require 'debug'
require 'logger'
require 'digest'
require 'cgi'

require_relative 'web_socket'
require_relative 'console'

class App < ::Sinatra::Base
  use ::WebSocket::Middleware

  get '/' do
    'Hello World'
  end
end

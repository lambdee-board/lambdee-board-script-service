# frozen_string_literal: true

require 'sinatra/base'

require_relative '../web_socket'

class ::Controllers::App < ::Sinatra::Base
  use ::WebSocket::Middleware

  get '/' do
    'Hello World'
  end
end

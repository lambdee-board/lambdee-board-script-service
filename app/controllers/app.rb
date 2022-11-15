# frozen_string_literal: true

require 'sinatra/base'
require 'json'

require_relative '../web_socket'
require_relative '../workers'

class ::Controllers::App < ::Sinatra::Base
  use ::WebSocket::Middleware

  post '/execute' do
    auth_scheme, auth_token = request.env['HTTP_AUTHORIZATION']&.split(' ')
    if auth_scheme.nil? || (auth_scheme != 'Lambdee' && auth_token != ::Config::LAMBDEE_BACKEND_SECRET) # rubocop:disable Style/IfUnlessModifier
      return [422, { 'Content-Type' => 'application/json' }, { error: 'Unauthorized access!' }.to_json]
    end

    request.body.rewind  # in case something already read it
    data = ::JSON.parse request.body.read, symbolize_names: true
    ::Workers::Ruby::Script.execute(data[:content], data[:script_run_id])
  end
end

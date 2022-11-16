# frozen_string_literal: true

require 'sinatra/base'
require 'json'

require_relative '../web_socket'
require_relative '../workers'

class ::Controllers::App < ::Sinatra::Base
  use ::WebSocket::Middleware

  post '/execute' do
    unless authenticate_lambdee(request.env['HTTP_AUTHORIZATION']) # rubocop:disable Style/IfUnlessModifier
      return [422, { 'Content-Type' => 'application/json' }, { error: 'Unauthorized access!' }.to_json]
    end

    request.body.rewind  # in case something already read it
    data = ::JSON.parse request.body.read, symbolize_names: true
    ::Workers::Ruby::Script.execute(data[:content], data[:script_run_id])
  end

  private

  # @param auth_header [String, nil]
  # @return [Boolean]
  def authenticate_lambdee(auth_header)
    auth_scheme, auth_token = auth_header&.split(' ')
    auth_scheme && auth_scheme == 'Lambdee' && auth_token == ::Config::LAMBDEE_BACKEND_SECRET
  end
end

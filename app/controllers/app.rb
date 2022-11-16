# frozen_string_literal: true

require 'sinatra/base'
require 'json'
require 'active_support/all'

require_relative '../web_socket'
require_relative '../workers'

class ::Controllers::App < ::Sinatra::Base
  use ::WebSocket::Middleware

  post '/api/execute' do
    unless authenticate(request.env['HTTP_AUTHORIZATION']) # rubocop:disable Style/IfUnlessModifier
      return [422, { 'Content-Type' => 'application/json' }, { error: 'Unauthorized access!' }.to_json]
    end

    request.body.rewind  # in case something already read it
    data = ::JSON.parse request.body.read, symbolize_names: true
    ::Workers::Ruby::Script.execute(data[:content], data[:script_run_id])
  end

  private

  # @param auth_header [String, nil]
  # @return [Boolean]
  def authenticate(auth_header)
    auth_scheme, credentials = auth_header&.split(' ')
    return false unless auth_scheme == 'Basic' && credentials

    ::ActiveSupport::SecurityUtils.secure_compare(::Base64.decode64(credentials), "#{::Config::API_USER}:#{::Config::API_PASSWORD}")
  end
end

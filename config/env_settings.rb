# frozen_string_literal: true

require 'uri'

module Config
  # @return [String]
  LAMBDEE_HOST = ::ENV['LAMBDEE_HOST'] || 'localhost:3000'
  # @return [String]
  LAMBDEE_PROTOCOL = ::ENV['LAMBDEE_PROTOCOL'] || 'http'
  # @return [URI::Generic]
  LAMBDEE_API_URI = URI "#{LAMBDEE_PROTOCOL}://#{LAMBDEE_HOST}/api"
  # Secret key used by this app to authenticate
  # with the main Lambdee API server.
  #
  # @return [String]
  SCRIPT_SERVICE_SECRET = ::ENV['SCRIPT_SERVICE_SECRET'] || 'sikritToken123'
  # HTTP Authorisation header used by this app to authenticate
  # with the main Lambdee API Service
  #
  # @return [String]
  LAMBDEE_API_AUTHORISATION_HEADER = "ScriptService #{SCRIPT_SERVICE_SECRET}"
  # Secret key used by the main Lambdee backend app to
  # authenticate with this Script Service.
  #
  # @return [String]
  LAMBDEE_BACKEND_SECRET = ::ENV['LAMBDEE_BACKEND_SECRET'] || 'sikritToken123'
  # Maximum amount of seconds for executing a script.
  #
  # @return [Integer]
  SCRIPT_EXECUTION_TIMEOUT = 4
end

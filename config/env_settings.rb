# frozen_string_literal: true

require 'uri'

module Config
  # @return [String]
  LAMBDEE_HOST = ::ENV['LAMBDEE_HOST'] || 'localhost:3000'
  # @return [String]
  LAMBDEE_PROTOCOL = ::ENV['LAMBDEE_PROTOCOL'] || 'http'
  # @return [URI::Generic]
  LAMBDEE_API_URI = URI "#{LAMBDEE_PROTOCOL}://#{LAMBDEE_HOST}/api"
end

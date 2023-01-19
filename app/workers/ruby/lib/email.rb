# frozen_string_literal: true

require 'json'
require_relative '../../../lambdee_api'

# Send emails from your Lambdee app.
module Email
  class << self
    # @param to [String]
    # @param subject [String]
    # @param content [String]
    # @return [Boolean]
    def send(to:, subject:, content:)
      resp = ::LambdeeAPI.http_connection.post('mails') do |r|
        r.body = {
          to:,
          subject:,
          content:
        }.to_json
      end

      return true if resp.status == 200

      false
    end
  end
end

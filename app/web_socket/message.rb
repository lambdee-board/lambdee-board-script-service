# frozen_string_literal: true

require_relative '../json/message'

module WebSocket
  # Provides standard ways of encoding and decoding
  # WebSocket messages.
  class Message < ::JSON::Message
  end
end

# frozen_string_literal: true

require_relative '../json/message'

module UnixSocket
  # Provides methods for encoding and decoding
  # UNIX Socket messages in a standard and extensible way.
  #
  # Every message is preceded by a header of 4 bytes encoded in the
  # 32-bit unsigned Integer, network (big-endian) byte order.
  # This header signifies the length of the upcoming message body.
  class Message < ::JSON::Message
    # @return [Integer] Max length of the payload in bytes
    MAX_LENGTH = 1_048_576
    # Format string passed to `String#unpack1` and `Array#pack`
    # for decoding and encoding the header respectively.
    #
    # @return [String]
    HEADER_FORMAT = 'N'
    # @return [Integer] Number of bytes that the header occupies.
    HEADER_BYTES = 4

    class << self
      # @param header [String, nil]
      # @return [Integer, nil]
      def decode_header(header)
        header&.unpack1(HEADER_FORMAT)
      end

      alias decode_body decode
    end

    # @return [String] Encoded size of the message body in bytes.
    def header
      [body.bytesize].pack(HEADER_FORMAT)
    end

    # @return [Integer]
    def bytesize
      body.bytesize
    end

    # @return [String] encoded payload of the message.
    def body
      @body ||= encode
    end
  end
end

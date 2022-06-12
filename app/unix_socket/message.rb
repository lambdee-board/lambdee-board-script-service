# frozen_string_literal: true

require 'msgpack'

# Add a separate type for Symbol serialisation, so that
# decoding an encoded message containing Symbols, will
# result in Symbols and not Strings.
::MessagePack::DefaultFactory.register_type(0x00, ::Symbol)

module UnixSocket
  # Provides methods for encoding and decoding
  # UNIX Socket messages in a standard and extensible way.
  #
  # Every message is preceded by a header of 4 bytes encoded in the
  # 32-bit unsigned Integer, network (big-endian) byte order.
  # This header signifies the length of the upcoming message body.
  #
  # The body itself is encoded in the MessagePack format (similar to JSON but low-level).
  # This means that it's possible to serialize almost any Ruby Object.
  class Message
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

      # @param body [String] MessagePack encoded body
      # @return [Hash{Symbol => Object}]
      def decode_body(body)
        ::MessagePack.unpack(body)
      end
    end

    # @param payload [Hash{Symbol => Object}]
    def initialize(payload)
      @payload = payload
    end

    # @return [String] Encoded size of the message body in bytes.
    def header
      [body.bytesize].pack(HEADER_FORMAT)
    end

    # @return [Integer]
    def bytesize
      body.bytesize
    end

    # @return [String] MessagePack encoded payload of the message.
    def body
      @body ||= ::MessagePack.pack(@payload)
    end
  end
end

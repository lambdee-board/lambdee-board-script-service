# frozen_string_literal: true

module UnixSocket
  # Wraps a UNIX Socket and provides a simpler
  # standard API for communicating through it.
  class Connection
    class Error < ::StandardError; end

    class << self
      # @param path [String]
      # @return [self]
      def open(path)
        ::LOGGER.info "Opening #{path}"
        new(::Socket.unix(path))
      rescue ::Errno::ENOENT => e
        raise Error, e.message
      end
    end

    # @param socket [Socket]
    def initialize(socket)
      @socket = socket
    end

    # @param payload [Hash{Symbol => Object}]
    # @return [void]
    def send(payload)
      message = Message.new(payload)
      @socket.print(message.header)
      ::LOGGER.debug "sent header #{message.bytesize}"
      @socket.print(message.body)
      ::LOGGER.debug "sent body #{payload}"
    end

    alias write send

    # @return [Hash{Symbol => Object}] Payload of the message.
    def read
      ::LOGGER.debug 'waiting for a header'
      body_size = Message.decode_header(@socket.read(Message::HEADER_BYTES))
      ::LOGGER.debug "received header #{body_size}"
      body = Message.decode_body(@socket.read(body_size))
      ::LOGGER.debug "received body #{body}"
      body
    end

    def close
      @socket.close
    end
  end
end

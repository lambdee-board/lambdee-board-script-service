# frozen_string_literal: true

module UnixSocket
  # Wraps a UNIX Socket and provides a simpler
  # standard API for communicating through it.
  class Connection
    class Error < ::StandardError; end
    class WouldBlockError < Error; end

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

    # @return [Socket]
    attr_reader :socket

    # @param type [Symbol, String]
    # @param payload [Hash, Array, String, Symbol, Integer, nil]
    # @return [void]
    def send(type:, payload: nil)
      message = Message.new(type:, payload:)
      @socket.print(message.header)
      ::LOGGER.debug "sent header #{message.bytesize}"

      @socket.print(message.body)
      ::LOGGER.debug "sent body #{message.inspect}"
    rescue ::Errno::EPIPE => e
      raise Error, e.message
    end

    alias write send

    # @return [UnixSocket::Message] Payload of the message.
    def read
      ::LOGGER.debug 'waiting for a header'
      body_size = Message.decode_header(@socket.read(Message::HEADER_BYTES))
      ::LOGGER.debug "received header #{body_size.inspect}"
      raise Error, 'Header is nil!' if body_size.nil?

      body = Message.decode_body(@socket.read(body_size))
      ::LOGGER.debug "received body #{body.inspect}"

      body
    rescue ::Errno::EPIPE => e
      raise Error, e.message
    end

    # @return [UnixSocket::Message] Payload of the message.
    def read_nonblock
      ::LOGGER.debug 'waiting for a header'
      body_size = Message.decode_header(@socket.recv_nonblock(Message::HEADER_BYTES))
      ::LOGGER.debug "received header #{body_size.inspect}"
      raise Error, 'Header is nil!' if body_size.nil?

      body = Message.decode_body(@socket.read(body_size))
      ::LOGGER.debug "received body #{body.inspect}"

      body
    rescue ::Errno::EPIPE => e
      raise Error, e.message
    rescue ::IO::EAGAINWaitReadable => e
      raise WouldBlockError, e.message
    end

    # Close the socket.
    #
    # @return [void]
    def close
      @socket.close
    end
  end
end

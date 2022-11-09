# frozen_string_literal: true

require 'stringio'

module UnixSocket
  # Acts as a stdout which saves everything to an
  # internal `String` and sends everything through
  # a UNIX Socket.
  class Stdout < ::StringIO
    # @param connection [UnixSocket::Connection]
    def initialize(connection)
      @connection = connection
      super()
    end

    # @param args [Array<String>]
    # @return [Integer]
    def write(*args)
      string = args.join

      @connection.write(type: :output,
                        payload: string)

      string.bytesize
    end
  end
end

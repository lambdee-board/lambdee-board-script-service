require 'stringio'

module UnixSocket
  class Stdout < StringIO
    # @param connection [Connection]
    def initialize(connection)
      @connection = connection
      super()
    end

    # @param args [Array<String>]
    # @return
    def write(*args)
      string = args.join

      @connection.write({ type: :output,
                          payload: string })

      string.bytesize
    end
  end
end

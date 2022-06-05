# frozen_string_literal: true

module WebSocket
  class Controller
    def initialize
      @session = ::Console::Session.new
    end

    # @param connection [Iodine::Connection]
    def on_open(connection)
      connection.write <<~TXT
        Connected to the Lambdee Console
        Ruby: #{::RUBY_VERSION}
      TXT
      # this will get hit after you attach your Controller to a request
    end

    # @param connection [Iodine::Connection]
    def on_message(connection, data)
      output = @session.evaluate data
      connection.write output.gsub(/\e\[(\d*);?(\d*)m/, '')
      # this will get hit when your client sends a message via the websocket
    end

    # @param connection [Iodine::Connection]
    def on_drained(connection)
      # this will get hit when the the connection.write buffer becomes empty
    end

    # @param connection [Iodine::Connection]
    def on_shutdown(connection)
      # this will get hit when you close down the websocket connection from the server
      connection.write <<~TXT
        Closing the session
      TXT
    end

    # @param connection [Iodine::Connection]
    def on_close(connection)
      # this will get hit when a websocket connection gets closed from the client
      connection.write <<~TXT
        Closing the session
      TXT
    end
  end
end

# frozen_string_literal: true

require 'json'

module WebSocket
  class Controller
    def initialize
      @session = ::Console::Session.new
    end

    # This will get hit after this Controller gets attached to a request
    #
    # @param connection [Iodine::Connection]
    def on_open(connection)
      connection.write Message.encode(
        type: :console_output,
        payload: {
          output: <<~TXT,
            Connected to the Lambdee Console
            Ruby: #{::RUBY_VERSION}
          TXT
        }
      )
    end

    # This will get hit when the client sends a message via the websocket
    #
    # @param connection [Iodine::Connection]
    def on_message(connection, data)
      message = Message.decode(data)
      case message.type
      when :console_input
        output = @session.evaluate message.dig('payload', 'input')
        connection.write Message.encode(
          type: :console_output,
          payload: {
            output: output.chomp.strip
          }
        )
      end
    end

    # This will get hit when the the connection.write buffer becomes empty
    #
    # @param connection [Iodine::Connection]
    def on_drained(connection)
    end

    # This will get hit when the websocket connection gets closed from the server
    #
    # @param connection [Iodine::Connection]
    def on_shutdown(connection)
      connection.write Message.encode(
        type: :console_output,
        payload: {
          output: 'Closing the session'
        }
      )
    end

    # This will get hit when the websocket connection gets closed from the client
    #
    # @param connection [Iodine::Connection]
    def on_close(connection)
      connection.write Message.encode(
        type: :console_output,
        payload: {
          output: 'Closing the session'
        }
      )
    end
  end
end

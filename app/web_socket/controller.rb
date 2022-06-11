# frozen_string_literal: true

require 'json'

module WebSocket
  class Controller
    # This will get hit after this Controller gets attached to a request
    #
    # @param connection [Iodine::Connection]
    def on_open(connection)
      @code_runner = ::CodeRunner.new
      connection.close if @code_runner.closed?

      connection.write Message.encode(
        type: :console_output,
        payload: {
          output: <<~TXT
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
        @code_runner.connection.write({ type: :input,
                                        payload: message.dig('payload', 'input') })

        connection.write Message.encode(
          type: :console_output,
          payload: {
            output: @code_runner.connection.read&.[](:payload)&.chomp&.strip || ''
          }
        )
      end
    rescue ::UnixSocket::Connection::Error
      @code_runner.close
      connection.close
    end

    # This will get hit when the the connection.write buffer becomes empty
    #
    # @param connection [Iodine::Connection]
    def on_drained(connection); end

    # This will get hit when the websocket connection gets closed from the server
    #
    # @param connection [Iodine::Connection]
    def on_shutdown(connection)
      @code_runner&.close
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
      @code_runner&.close
      connection.write Message.encode(
        type: :console_output,
        payload: {
          output: 'Closing the session'
        }
      )
    end
  end
end

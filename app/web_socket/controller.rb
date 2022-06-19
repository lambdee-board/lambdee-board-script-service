# frozen_string_literal: true

require_relative '../workers'

module WebSocket
  # Controls websocket connections with the browser.
  class Controller
    # This will get hit after this Controller gets attached to a request
    #
    # @param connection [Iodine::Connection]
    def on_open(connection)
      @repl_worker = ::Workers::REPL.new
      connection.close if @repl_worker.closed?

      connection.write Message.encode(
        type: :console_output_end,
        payload: <<~TXT)
          Connected to the Lambdee Console
          Ruby: #{::RUBY_VERSION}
        TXT
    end

    # This will get hit when the client sends a message via the websocket
    #
    # @param connection [Iodine::Connection]
    def on_message(connection, data)
      message = Message.decode(data)
      case message.type
      when :console_input
        @repl_worker.connection.write(type: :input,
                                      payload: message.dig(:payload, :input))

        loop do
          repl_response = @repl_worker.connection.read
          break if repl_response.nil?
          break if repl_response.type == :output_end

          connection.write Message.encode(
            type: :console_output,
            payload: repl_response.payload || ''
          )
        end

        connection.write Message.encode(
          type: :console_output_end
        )
      end
    rescue ::UnixSocket::Connection::Error
      @repl_worker.close
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
      @repl_worker&.close
      connection.write Message.encode(
        type: :console_output,
        payload: 'Closing the session'
      )
    end

    # This will get hit when the websocket connection gets closed from the client
    #
    # @param connection [Iodine::Connection]
    def on_close(connection)
      @repl_worker&.close
      connection.write Message.encode(
        type: :console_output,
        payload: 'Closing the session'
      )
    end
  end
end

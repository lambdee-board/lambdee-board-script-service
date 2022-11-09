# frozen_string_literal: true

require_relative '../workers'
require_relative '../lambdee_api'

module WebSocket
  # Controls websocket connections with the browser.
  class Controller
    # This will get hit after this Controller gets attached to a request
    #
    # @param connection [Iodine::Connection]
    # @return [void]
    def on_open(connection)
      @auth_complete = false

      connection.write Message.encode(
        type: :info,
        payload: 'Connection established.'
      )
    end

    # This will get hit when the client sends a message via the websocket
    #
    # @param connection [Iodine::Connection]
    # @param data [String, nil]
    # @return [void]
    def on_message(connection, data)
      return authorise(connection, data) unless @auth_complete

      authorised_message(connection, data)
    end

    # This will get hit when the the connection.write buffer becomes empty
    #
    # @param connection [Iodine::Connection]
    # @return [void]
    def on_drained(connection); end

    # This will get hit when the websocket connection gets closed from the server
    #
    # @param connection [Iodine::Connection]
    # @return [void]
    def on_shutdown(connection)
      @repl_worker&.close
      connection.write Message.encode(
        type: :console_output,
        payload: 'Closing the session.'
      )
    end

    # This will get hit when the websocket connection gets closed from the client
    #
    # @param connection [Iodine::Connection]
    # @return [void]
    def on_close(connection)
      @repl_worker&.close
      connection.write Message.encode(
        type: :console_output,
        payload: 'Closing the session'
      )
    end

    private

    # @param connection [Iodine::Connection]
    # @param data [String, nil]
    # @return [void]
    def authorised_message(connection, data)
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

    # @param connection [Iodine::Connection]
    # @param data [String, nil]
    # @return [void]
    def authorise(connection, data)
      message = Message.decode(data)
      return connection.close unless message.type == :auth

      response = ::LambdeeAPI.http_connection.get('users/current') do |req|
        req.headers['Authorization'] = message.dig(:payload, :token)
      end

      return unauthenticated!(connection) if response.status != 200

      json = ::JSON.parse response.body, symbolize_names: true
      return unauthorised!(connection) unless %w[admin developer].include? json[:role]

      connection.write Message.encode(
        type: :info,
        payload: <<~TXT
          Connected to the Lambdee Console.
          Ruby: #{::RUBY_VERSION}
        TXT
      )

      @repl_worker = ::Workers::Ruby::REPL.new
      connection.close if @repl_worker.closed?
      @auth_complete = true
    end

    # @param connection [Iodine::Connection]
    # @return [void]
    def unauthenticated!(connection)
      connection.write Message.encode(
        type: :info,
        payload: 'Unauthenticated!'
      )
      connection.close
    end

    # @param connection [Iodine::Connection]
    # @return [void]
    def unathorised!(connection)
      connection.write Message.encode(
        type: :info,
        payload: 'Unauthorised access!'
      )
      connection.close
    end
  end
end

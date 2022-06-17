# frozen_string_literal: true

module WebSocket
  # Middleware which captures websocket upgrade requests
  # and hands them to the appropriate websocket controller.
  class Middleware
    # @param app [Sinatra::Base] Sinatra controller
    def initialize(app)
      @app = app
    end

    # @param env [Hash{String, Symbol => Object}]
    def call(env)
      if env['rack.upgrade?'] == :websocket
        env['rack.upgrade'] = Controller.new
        return [200, {}, []]
      end

      @app.call(env)
    end
  end
end

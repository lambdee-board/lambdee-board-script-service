# frozen_string_literal: true

module WebSocket
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['rack.upgrade?'] == :websocket
        env['rack.upgrade'] = Controller.new
        return [200, {}, []]
      end

      @app.call(env)
    end
  end
end

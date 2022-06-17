# frozen_string_literal: true

# @abstract Subclass to test a Sinatra app/controller.
class ::ControllerTestCase < ::TestCase
  include ::Rack::Test::Methods

  def controller
    raise ::NotImplementedError, 'A controller test must implement the #controller method!'
  end

  def app
    controller
  end
end

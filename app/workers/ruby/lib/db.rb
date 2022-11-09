# frozen_string_literal: true

require_relative 'lambdee_api'
require_relative 'db/base_model'

::Dir[::File.expand_path('db/*', __dir__)].each { require _1 }

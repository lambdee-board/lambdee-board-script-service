# frozen_string_literal: true

module DB
  # Contains modules which provide
  # methods for defining associations
  # between database tables/records,
  # for fetching associated records etc.
  module QueryAPI; end
end

::Dir[::File.expand_path('query_api/*', __dir__)].each { require _1 }

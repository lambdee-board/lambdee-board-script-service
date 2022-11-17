# frozen_string_literal: true

require_relative '../../../lambdee_api'
require_relative 'db/base_model'

# Module which encapsulates classes
# which represent DataBase tables/records.
module DB
  class << self
    # @return [Array<DB::BaseModel>]
    def models
      BaseModel.model_table_name_map.values
    end
    alias tables models

    # @return [Array<Symbol>]
    def table_names
      BaseModel.model_table_name_map.keys
    end
  end
end

::Dir[::File.expand_path('db/*', __dir__)].each { require _1 }

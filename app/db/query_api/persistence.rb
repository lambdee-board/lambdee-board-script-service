# frozen_string_literal: true

require 'faraday'
require 'json'

require_relative '../../../config/env_settings'

module DB
  module QueryAPI
    # Provides methods for saving, updating and deleting records.
    module Persistence
      module ClassMethods
        # @param kwargs [Hash{Symbol => Object}]
        # @return [self]
        def create(**kwargs)
          obj = new(**kwargs)
          obj.save!
          obj
        end

        # @param record [Hash{String => Object}]
        # @return [self]
        def from_record(record)
          obj = from_hash(record)
          obj.persisted!
          obj
        end
      end

      module InstanceMethods
        # @return [Boolean]
        attr_reader :persisted
        # @return [Boolean]
        attr_reader :deleted
        # @return [Boolean]
        attr_reader :changed

        # @return [Boolean]
        def persisted?
          !!@persisted
        end

        # @return [void]
        def persisted!
          @persisted = true
        end

        # @return [Boolean]
        def deleted?
          !!@deleted
        end

        # @return [void]
        def deleted!
          @deleted = true
        end

        # TODO: implement changed?
        # @return [Boolean]
        def changed?
          !!@changed
        end

        # @return [void]
        def changed!
          @changed = true
        end

        # @return [self]
        def reload
          path = "#{self.class.table_name}/#{id}"
          response = ::LambdeeAPI.http_connection.get(path)
          raise InvalidQueryError, response if (300...500).include? response.status
          raise ServerFailure, response if response.status >= 500

          reload_from_json(response.body)

          self
        end

        # @return [self]
        # @raise [Error]
        def save!
          if persisted?
            path = "#{self.class.table_name}/#{id}"
            http_method = :put
          else
            path = self.class.table_name.to_s
            http_method = :post
          end

          response = ::LambdeeAPI.http_connection.public_send(http_method, path) do |req|
            req.body = to_json
          end
          raise InvalidRecordError, response if (300...500).include? response.status
          raise ServerFailure, response if response.status >= 500

          reload_from_json(response.body)

          self
        end

        # @return [self]
        def destroy
          return self if deleted? || !persisted?

          path = "#{self.class.table_name}/#{id}"
          response = ::LambdeeAPI.http_connection.delete(path)
          raise InvalidQueryError, response if (300...500).include? response.status
          raise ServerFailure, response if response.status >= 500

          deleted!
          freeze

          self
        end

        # @return [Boolean]
        def save
          save!
          true
        rescue Error
          false
        end

        private

        # @param json [String]
        # @return [void]
        def reload_from_json(json)
          json_response = ::JSON.parse(json, symbolize_names: true)
          json_response.each do |key, val|
            setter = :"#{key}="
            next unless respond_to?(setter)

            public_send(setter, val)
          end
        end

      end
    end
  end
end

# frozen_string_literal: true

require 'faraday'
require 'json'

module DB
  module QueryAPI
    # Provides methods for saving, updating and deleting records.
    module Persistence
      # Represents a single attribute change
      class AttributeChange
        # @return [Symbol]
        attr_accessor :name
        # @return [Object]
        attr_accessor :from
        # @return [Object]
        attr_accessor :to

        # @param name [Symbol]
        # @param from [Object]
        # @param to [Object]
        def initialize(name, from: nil, to: nil)
          @name = name
          @from = from
          @to = to
        end
      end

      # Class methods for models with persistence.
      module ClassMethods
        # @param kwargs [Hash{Symbol => Object}]
        # @return [self]
        def create(**kwargs)
          obj = new(**kwargs)
          obj.after_initialize!
          obj.save!
          obj
        end

        # @param hash [Hash{String => Object}]
        # @param kwargs [Hash]
        # @return [self]
        def of_hash(hash, **kwargs)
          obj = super
          obj.after_initialize!
          obj
        end

        # @param record [Hash{String => Object}]
        # @return [self]
        def from_record(record)
          obj = from_hash(record)
          obj.persisted!
          obj
        end

        # @param args [Array]
        # @param kwargs [Hash]
        # @return [void]
        def attribute(*args, **kwargs)
          super
          attr_name = args.first
          persistence_methods.define_method :"#{attr_name}=" do |val|
            register_attribute_change(attr_name, from: public_send(attr_name), to: val) if after_initialize?
            super(val)
          end
          persistence_methods.define_method :"#{attr_name}?" do
            !public_send(attr_name).nil?
          end
        end

        private

        # @return [Module]
        def persistence_methods
          @persistence_methods ||= ::Module.new.tap { include _1 }
        end
      end

      # Instance methods for models with persistence.
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
          return if persisted?

          after_initialize!
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

        # @return [ActiveSupport::HashWithIndifferentAccess]
        def changed_attributes
          @changed_attributes ||= ::ActiveSupport::HashWithIndifferentAccess.new
        end

        # @return [Boolean]
        def changed?
          !changed_attributes.empty?
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

        # @param trigger_scripts [Boolean]
        # @return [self]
        # @raise [Error]
        def save!(trigger_scripts: false)
          if persisted?
            path = "#{self.class.table_name}/#{id}"
            http_method = :put
          else
            path = self.class.table_name.to_s
            http_method = :post
          end

          response = ::LambdeeAPI.http_connection.public_send(http_method, path) do |req|
            req.body = update_create_body(trigger_scripts: trigger_scripts)
          end
          raise InvalidRecordError, response if (300...500).include? response.status
          raise ServerFailure, response if response.status >= 500

          reload_from_json(response.body)
          persisted!

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

        # @param trigger_scripts [Boolean]
        # @return [Boolean]
        def save(trigger_scripts: false)
          save!(trigger_scripts:)
          true
        rescue Error
          false
        end

        # @return [Boolean]
        def after_initialize?
          !!@after_initialize
        end

        # @return [void]
        def after_initialize!
          @after_initialize = true
        end

        private

        # @param trigger_scripts [Boolean]
        # @return [String]
        def update_create_body(trigger_scripts: false)
          {
            **as_json,
            trigger_scripts:
          }.to_json
        end

        # @return [void]
        def reset_changed_attributes
          @changed_attributes = ::ActiveSupport::HashWithIndifferentAccess.new
        end

        # @param json [String]
        # @return [void]
        def reload_from_json(json)
          json_response = ::JSON.parse(json, symbolize_names: true)
          json_response.each do |key, val|
            setter = :"#{key}="
            next unless respond_to?(setter)

            public_send(setter, val)
          end
          reset_changed_attributes
        end

        # @param name [Symbol]
        # @param from [Object]
        # @param to [Object]
        # @return [void]
        def register_attribute_change(name, from: nil, to: nil)
          unless (changed_attribute = changed_attributes[name])
            changed_attributes[name] = AttributeChange.new(name, from:, to:)
            return
          end

          changed_attribute.to = to
          nil
        end

      end
    end
  end
end

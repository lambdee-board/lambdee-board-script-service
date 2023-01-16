# frozen_string_literal: true

require 'json'
require_relative '../../../lambdee_api'

# Allows you to access Script
# Variables which have been defined.
module SCRIPT_VARS # rubocop:disable Naming/ClassAndModuleCamelCase
  @cache = {}

  class << self
    # @return [Hash{Symbol => String, nil}]
    attr_reader :cache

    # @param var_name [Symbol, String]
    # @return [String, nil]
    def [](var_name)
      var_name = var_name.to_sym
      return @cache[var_name] if @cache.include?(var_name)

      get(var_name)
    end

    # @param var_name [Symbol, String]
    # @return [Boolean]
    def include?(var_name)
      var_name = var_name.to_sym
      !self[var_name].nil?
    end

    # @return [void]
    def clear_cache
      @cache = {}
    end

    private

    # @param var_name [Symbol, String]
    # @return [String, nil]
    def get(var_name)
      var_name = var_name.to_sym
      resp = ::LambdeeAPI.http_connection.get("script_variables/#{var_name}") do |r|
        r.params['by_name'] = true
        r.params['decrypt'] = true
      end

      return @cache[var_name] = nil unless resp.status == 200

      json = ::JSON.parse resp.body
      @cache[var_name] = json['value']
    rescue ::JSON::ParserError
      @cache[var_name] = nil
    end
  end

end

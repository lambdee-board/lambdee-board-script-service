# frozen_string_literal: true

require 'json'

module JSON
  # A standard way of encoding and decoding JSON messages.
  class Message
    class MalformedMessageError < ::StandardError; end

    class << self
      # @return [String] JSON encoded message
      def encode(...)
        new(...).encode
      end

      # @param body [String] encoded body
      # @return [self]
      # @raise [MalformedMessageError]
      def decode(body)
        decoded = ::JSON.parse(body, symbolize_names: true)

        new(type: decoded[:type], payload: decoded[:payload])
      rescue ::NoMethodError => e
        raise MalformedMessageError, e.message
      end
    end

    # @param :type [Symbol, String]
    # @param :payload [Hash, Array, String, Symbol, Integer, nil]
    def initialize(type:, payload: nil)
      @type = type.to_sym
      @payload = payload
    end

    # @return [Symbol]
    attr_reader :type

    # @return [Hash, nil]
    attr_reader :payload

    # Functions like `Hash#dig`
    def dig(*args)
      return if args.empty?

      return unless respond_to?(key = args.shift)

      value = public_send(key)
      return if value.nil?
      return value if args.size.zero?
      raise ::TypeError, "#{value.class} does not have #dig method" unless value.respond_to?(:dig)

      value.dig(*args)
    end

    # @return [Hash{Symbol => Object}]
    def to_h
      {
        type:,
        payload:
      }.compact
    end

    # @return [String] JSON encoded message
    def encode
      to_h.to_json
    end

    # @return [String]
    def inspect
      "#{self.class}{type: #{type.inspect}, payload: #{payload.inspect}}"
    end
  end
end

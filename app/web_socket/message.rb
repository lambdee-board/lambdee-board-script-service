# frozen_string_literal: true

class Message
  class << self
    # @return [String] JSON encoded message
    def encode(...)
      new(...).encode
    end

    # @param message [String]
    # @return [self]
    def decode(message)
      decoded_json = ::JSON.parse(message)
      new(type: decoded_json['type'], payload: decoded_json['payload'])
    end
  end

  # @param :type [Symbol, String]
  # @param :payload [Hash, nil]
  def initialize(type:, payload: nil)
    @type = type.to_sym
    @payload = payload
  end

  # @return [Symbol]
  attr_reader :type

  # @return [Hash, nil]
  attr_reader :payload

  def dig(*args)
    return if args.empty?

    return unless respond_to?(key = args.shift)

    value = public_send(key)
    return if value.nil?
    return value if args.size.zero?
    raise TypeError, "#{value.class} does not have #dig method" unless value.respond_to?(:dig)

    value.dig(*args)
  end

  # @return [String] JSON encoded message
  def encode
    {
      type:,
      payload:
    }.to_json
  end
end

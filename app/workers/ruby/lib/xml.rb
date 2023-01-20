# frozen_string_literal: true

require 'nokogiri'

# Parse and build XML documents.
module XML
  class InvalidRootError < ::StandardError; end

  class << self
    # Parse a XML document to a Hash.
    #
    # @param string [String]
    # @return [Hash]
    def parse(string)
      ::Hash.from_xml(string)
    end
    alias decode parse

    # Convert a hash to an XML document.
    #
    # @param hash [Hash]
    # @return [String] XML encoded string
    def unparse(hash)
      raise TypeError, "Expected `Hash`, got `#{hash.class}` (#{hash.inspect})" unless hash.is_a?(::Hash)
      raise InvalidRootError, "Only one root element is permitted in XML! (#{hash.inspect})" if hash.size > 1
      raise InvalidRootError, 'No root element!' if hash.empty?

      root_name = hash.keys.first
      internal_hash = hash[root_name]
      internal_hash.to_xml(root: root_name, skip_types: true)
    end
    alias encode unparse
    alias stringify unparse

    # See [Nokogiri](https://nokogiri.org/rdoc/Nokogiri/XML/Builder.html)
    # for more details.
    #
    # @param namespace_inheritance [Boolean]
    # @yieldparam [Nokogiri::XML::Builder]
    # @return [String]
    def build(namespace_inheritance: true, &block)
      result = ::Nokogiri::XML::Builder.new(namespace_inheritance:) do |xml|
        block.call(xml)
      end
      result.to_xml
    end
  end
end

require_relative 'xml/faraday_middleware'

# loads all classes
# which should be available in the Script API

require 'stringio'
require 'json'
require 'active_support/all'
require 'active_support/xml_mini'

require_relative 'db'
require_relative 'script_vars'
require_relative 'http_request'
require_relative 'xml'
require_relative 'json'
require_relative 'email'

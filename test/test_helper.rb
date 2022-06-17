# frozen_string_literal: true

$LOAD_PATH.unshift ::File.expand_path("../app", __dir__)
require 'minitest/autorun'
require 'debug'

require_relative '../app'
require_relative 'test_case'
require_relative 'controller_test_case'

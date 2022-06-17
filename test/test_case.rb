# frozen_string_literal: true

# @abstract Subclass to define a new test case.
class ::TestCase < ::Minitest::Test
  # Name of the current test.
  #
  # @return [String]
  def name_of_test
    self.name.to_s.delete_prefix('test_')
  end
end

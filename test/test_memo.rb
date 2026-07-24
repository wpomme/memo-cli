# frozen_string_literal: true

require_relative "helper"

class TestMemo < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Memo::VERSION
  end
end

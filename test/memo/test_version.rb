# frozen_string_literal: true

require_relative "../helper"

class TestVersion < Minitest::Test
  describe "Memo::Version" do
    it "Memo::Versionが存在すること" do
      refute_nil ::Memo::VERSION
    end
  end
end

# frozen_string_literal: true

require_relative '../../../helper'

class TestFileTag < Minitest::Test
  describe('Controller::FileTag') do
    include MemoDBTestLifecycleHooks

    describe('#seeds') do
      def setup
        super
        Memo::Database::CONTROLLER_NAMES.each do |name|
          klass = Object.const_get("Memo::Database::Controller::#{name}")
          klass.new.seeds
        end
      end

      def teardown
        Memo::Database::CONTROLLER_NAMES.reverse.each do |name|
          klass = Object.const_get("Memo::Database::Controller::#{name}")
          klass.new.delete
        end
        super
      end

      it('戻り値の配列の数が、重複を排除しないタグの出現回数と同じになること') do
        actual = Memo::Database::Controller::FileTag.new.count

        expected = Memo::Loader::FileLoader.new.total_tag_size

        _(actual).must_equal(expected)
      end
    end
  end
end

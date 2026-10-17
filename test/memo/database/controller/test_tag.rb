# frozen_string_literal: true

require_relative '../../../helper'

class TestTag < Minitest::Test
  describe('Controller::Tag') do
    include MemoDBTestLifecycleHooks

    def setup
      super
      @dataset = Memo::Database::Controller::Tag.new

      @seeds = @dataset.seeds
    end

    def teardown
      @dataset.delete
      super
    end

    describe('#seeds') do
      it('戻り値の配列の数が、重複を排除したタグの総数と同じになること') do
        actual = @seeds.size

        expected = Memo::Loader::FileLoader.new.tag_size

        _(actual).must_equal(expected)
      end
    end
  end
end

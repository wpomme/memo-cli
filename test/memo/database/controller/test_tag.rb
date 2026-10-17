# frozen_string_literal: true

require_relative '../../../helper'

class TestTag < Minitest::Test
  describe('Controller::Tag') do
    include MemoDBTestLifecycleHooks

    def setup
      dataset = Memo::Database::Controller::Tag.new

      @seeds = dataset.seeds
    end

    def teardown
      Memo::Database::DB[:tags].delete
      super
    end

    describe('#seeds') do
      it('戻り値の配列の数が、重複を排除したタグの総数と同じになること') do
        actual = @seeds.size

        file_loader = Memo::Database::FileLoader.new
        expected = file_loader.all_tag_count_of_list

        _(actual).must_equal(expected)
      end
    end
  end
end

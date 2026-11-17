# frozen_string_literal: true

require_relative '../../helper'

class TestViewSearch < Minitest::Test
  describe 'ViewModel::Search' do
    include MemoLifecycleHooks

    def setup
      super
      @vm = Memo::ViewModel::Search.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#execute' do
      it '見つからなかった場合' do
        word = 'does_not_exist_words'

        actual = @vm.execute(word)

        expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', word)

        _(actual).must_equal(expected)
      end

      it '検索結果が見つかった場合' do
        skip 'TODO'
        word = 'ls'

        actual = @vm.execute(word)

        _(actual).must_equal(expected)
      end
    end
  end
end

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
      it '検索文字列でヒットしなかった場合は、その旨のメッセージを表示すること' do
        word = 'does_not_exist_words'

        actual = @vm.execute(word)

        expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', word)

        _(actual).must_equal(expected)
      end

      it '検索文字列でヒットした場合は、行ごとに一定の形式に沿った文字列を表示すること' do
        word = 'a'

        ret = @vm.execute(word)

        actual = ret.all? do |line|
          # ./[任意の文字列].md:(数字):[任意の文字列]
          %r{\A\./.+\.md:\d+:.+\Z}.match?(line)
        end

        _(actual).must_equal(true)
      end
    end
  end
end

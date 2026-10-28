# frozen_string_literal: true

require_relative '../../helper'

class TestViewTag < Minitest::Test
  include Memo::Message

  describe 'View::Tag' do
    include MemoLifecycleHooks

    def setup
      super
      @view = Memo::View::Tag.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#run' do
      it '見つかった場合、FileLoaderからのタグの数とTag.runによるタグの数は同じになる' do
        search_word = 'CLI'

        # タグの文字列が入っている配列の方を取得して、スペースでsplitしてsizeを取る
        actual = @view.run(search_word).last.split.size

        expected = @file_loader.tag_files_size[search_word]

        _(actual).must_equal(expected)
      end

      it '見つからなかった場合、エラーメッセージを表示する' do
        search_word = 'does_not_exist_words'
        tag_list = @file_loader.sorted_tags

        actual = @view.run(search_word)

        expected = NO_TAGS.sub('tag', search_word) << tag_list.join(' ')

        _(actual).must_equal(expected)
      end
    end
  end
end

# frozen_string_literal: true

# require_relative '../../helper'

class TestViewTag < Minitest::Test
  describe 'View::Tag' do
    describe '#run' do
      it '見つからなかった場合、エラーメッセージを表示する' do
        search_word = 'does_not_exist_words'
        tag_list = Memo::FileLoader.new.sorted_tags

        actual = Memo::View::Tag.run(search_word)

        expected = Memo::Message::NO_TAGS.sub('tag', search_word) << tag_list.join(' ')

        _(actual).must_equal(expected)
      end

      it '見つかった場合、FileLoaderからのタグの数とTag.runによるタグの数は同じになる' do
        search_word = 'CLI'

        # タグの文字列が入っている配列の方を取得して、スペースでsplitしてsizeを取る
        actual = Memo::View::Tag.run(search_word).last.split.size

        expected = Memo::FileLoader.new.tag_files_hash[search_word].size

        _(actual).must_equal(expected)
      end
    end
  end
end

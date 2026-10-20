# frozen_string_literal: true

require_relative '../helper'

class TestView < Minitest::Test
  describe 'View' do
    def setup
      @neo_view = Memo::NeoView.new
    end

    describe '#read' do
      it 'NeoViewはreadメソッドを返す' do
        actual = @neo_view

        _(actual).must_respond_to(:read)
      end

      it 'ファイルが一件見つかったとき、そのファイルを全文表示する' do
        target_filename = 'ls'

        out, = capture_io do
          @neo_view.read(target_filename)
        end

        _(out).wont_be_empty
      end

      it 'ファイルが複数件と一致するとき、どのファイルを表示するかのプロンプトを表示し、選択したファイルを全文表示する' do
        target_filename = 'diff'

        count = 2

        # 最後の方を選択する
        $stdin = StringIO.new("#{count}\n")
        out, = capture_io do
          @neo_view.read(target_filename)
        end

        _(out).wont_be_empty
      ensure
        $stdin = STDIN
      end

      it 'ファイルが見つからない場合は、該当のメモがないことを示すメッセージを表示する' do
        word = 'does_not_exist_files'

        out, = capture_io do
          @neo_view.read(word)
        end

        _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word) << "\n")
      end
    end

    describe '#search' do
      it 'NeoViewはsearchメソッドを返す' do
        actual = @neo_view

        _(actual).must_respond_to(:search)
      end

      it '検索結果が見つかった場合' do
        search_word = 'ls'

        out, = capture_io do
          @neo_view.search(search_word)
        end

        _(out).wont_be_empty
      end

      it '検索結果が見つからなかった場合' do
        search_word = 'does_not_exist_word'

        out, = capture_io do
          @neo_view.search(search_word)
        end

        expected = Memo::Message::NO_SEARCH_RESULTS_WERE_FOUND.sub('word', search_word) << "\n"

        _(out).must_equal(expected)
      end
    end
  end
end

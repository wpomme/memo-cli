# frozen_string_literal: true

require_relative '../helper'

class TestView < Minitest::Test
  describe 'View' do
    def setup
      @neo_view = Memo::NeoView.new
    end

    describe '#read' do
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
        word = 'idoes_not_exist_files'

        out, = capture_io do
          @neo_view.read(word)
        end

        _(out).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word) << "\n")
      end
    end
  end
end

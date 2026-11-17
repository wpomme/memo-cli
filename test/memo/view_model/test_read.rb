# frozen_string_literal: true

require_relative '../../helper'

class TestViewRead < Minitest::Test
  describe 'ViewModel::Read' do
    include MemoLifecycleHooks

    def setup
      super
      @vw = Memo::ViewModel::Read.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#execute' do
      it 'ファイルが見つからない場合は、該当のメモがないことを示すメッセージを表示する' do
        word = 'does_not_exist_files'

        actual = @vw.execute(word)

        _(actual).must_equal(Memo::Message::NO_MEMOS_WEWE_FOUND.sub('word', word))
      end

      it 'ファイルが一件見つかったとき、そのファイルを全文表示する' do
        target_filename = 'ls'

        actual = @vw.execute(target_filename)

        _(actual).must_equal(Memo::MockSeed::TEST_LS_FILE_CONTENT)
      end

      it 'ファイルが複数件と一致するとき、どのファイルを表示するかのプロンプトを表示し、選択したファイルを全文表示する' do
        target_filename = 'diff'

        count = 2

        # 最後の方を選択する
        $stdin = StringIO.new("#{count}\n")
        out, = capture_io do
          @vw.execute(target_filename)
        end

        _(out).wont_be_empty
      ensure
        $stdin = STDIN
      end
    end
  end
end

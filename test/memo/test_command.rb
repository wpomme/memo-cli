# frozen_string_literal: true

require_relative "../test_helper"

class TestCommand < Minitest::Test
  describe 'Command' do
    include MemoTestLifecycleHooks

    describe '#execute' do
      describe 'args: dirs' do
        it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(['dirs'])
          end

          actual = @dir_set
          assert_equal actual, out.split("\n").to_set
        end
      end

      describe 'args: list' do
        it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(['list'])
          end

          assert_equal @test_to_files.flatten.to_set, out.split("\n").to_set
        end

        it "['list', 'cli']を受け取ったときは、memo_dirの中のcliディレクトリの中にあるメモファイルを全て表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(%w[list cli])
          end

          expected = @test_entries
            .filter_map { |entry| entry.filename if entry.dir == 'cli' }
            .sort
            .join("\n") << "\n"

          assert_equal expected, out
        end

        it "['list', 'invalid_dir']の場合、ユーザーメッセージ" do
          skip "TODO"
        end
      end

      describe 'args: read' do
        it "['read', 'find']を受け取ったときは、find.mdを全文表示する" do
          out, = capture_io do
            Memo::Command.new(@memo_dir).execute(%w[read find])
          end

          assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
        end

        it "['read', 'invalid_memo']を受け取ったときは、そのようなメモがないことを表示する" do
          word = 'invalid_memo'

          out, = capture_io do
            exception = assert_raises(SystemExit) do
              Memo::Command.new(@memo_dir).execute(%w[read invalid_memo])
            end

            assert_equal 2, exception.status
          end

          assert_equal "#{word} というメモは見つかりませんでした。\n", out
        end

        # Memo::Command::Options以下のParserの動作みたい
        it "['read', nil]を受け取ったときは、例外を送出する" do
          word = nil

          capture_io do
            exception = assert_raises(OptionParser::InvalidArgument) do
              Memo::Command.new(@memo_dir).execute(['read', word])
            end

            assert_equal "invalid argument: -r ", exception.message
          end
        end
      end
    end
  end
end

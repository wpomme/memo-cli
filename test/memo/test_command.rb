# frozen_string_literal: true

require_relative "../test_helper"

class TestCommand < Minitest::Test
  describe 'Command' do
    include MemoTestLifecycleHooks

    describe '#execute' do
      it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(['dirs'])
        end

        actual = @dir_set.to_a.sort.join("\n") << "\n"
        assert_equal actual, out
      end

      it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(['list'])
        end

        assert_equal @test_memo_list.flatten.join("\n") << "\n", out
      end

      it "['list', 'cli']を受け取ったときは、memo_dirの中のcliディレクトリの中にあるメモファイルを全て表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(%w[list cli])
        end

        expected = @test_entries
          .filter_map { |entry| File.basename(entry.full_path, '.md') if entry.dir == 'cli' }
          .sort
          .join("\n") << "\n"

        assert_equal expected, out
      end

      it "['read', 'find']を受け取ったときは、find.mdを全文表示する" do
        out, = capture_io do
          Memo::Command.new(@memo_dir).execute(%w[read find])
        end

        assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
      end
    end
  end
end

# frozen_string_literal: true

require "tmpdir"
require "fileutils"

require_relative "../test_helper"

class TestDocs < Minitest::Test
  describe 'Docs' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      describe '@entries' do
        it 'Docs#initializeは@entriesを生成し、@entriesは配列であり空ではない' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          assert_instance_of Array, entries
          refute_empty entries
        end

        it '@entriesはMemo::Docs::Entryの配列を返す' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          entries.each do |entry|
            assert_instance_of Memo::Docs::Entry, entry
          end
        end

        it '@entriesは期待するEntryの一覧と一致する' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          assert_equal @test_entries.sort_by(&:full_path), entries.sort_by(&:full_path)
        end

        it '@entries.full_pathはREADME(.md) を含まない' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)
          full_path = entries.map(&:full_path)

          refute_includes full_path, "README"
          refute_includes full_path, "README.md"
        end

        it '@entries:full_path は絶対パスである' do
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)
          full_paths = entries.map(&:full_path)

          full_paths.each do |full_path|
            assert File.absolute_path?(full_path)
          end
        end

        it 'Docs.new が空のmemo_dir を読み込んだ場合は、entries も空になる' do
          FileUtils.rm_rf(Dir.glob(File.join(@memo_dir, "*")))
          docs = Memo::Docs.new(@memo_dir)
          entries = docs.instance_variable_get(:@entries)

          assert_empty entries
        end
      end
    end

    # describe '#find_a_file' do
    #   it "memoの中に存在するファイルが見つかった場合は、そのファイルのEntryの配列を返す" do
    #     word = 'find'
    #     expected = Memo::Docs.new(@memo_dir).find_a_file(word)
    #     actual = [Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "find.md"), dir: "cli")]

    #     assert_equal actual, expected
    #   end

    #   it "memoの中に存在するファイルが複数見つかった場合は、複数のファイルのEntryの配列を返す" do
    #     word = 'grep'
    #     expected = Memo::Docs.new(@memo_dir).find_a_file(word)
    #     actual = [Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "cli", "grep.md"), dir: "cli"),
    #               Memo::Docs::Entry.new(full_path: File.join(@memo_dir, "setting", "grep.md"), dir: "setting")]

    #     assert_equal actual, expected
    #   end

    #   it "memoの中に存在しないwordが入力された場合は、空の配列を返す" do
    #     word = 'invalid_word'
    #     expected = Memo::Docs.new(@memo_dir).find_a_file(word)

    #     assert_equal [], expected
    #   end
    # end

    describe '#find_a_file -> #read_a_file' do
      it "entryが空でない場合は、" do
        expected = Memo::Docs.new(@memo_dir).find_a_file('find').read_a_file

        actual = MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT.split("\n")

        assert_equal actual, expected
      end

      #   it "entryが複数の場合" do
      #     skip "TODO"
      #   end

      #   it "entryがからの場合" do
      #     skip "TODO"
      #   end
    end

    describe '#read' do
      it 'memoディレクトリの中に存在するwordを受け取った場合は、そのファイルを全文表示する' do
        out, = capture_io do
          Memo::Docs.read(@memo_dir, "find")
        end

        assert_equal MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT, out
      end
    end

    describe '#dirs' do
      it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
        out, = capture_io do
          Memo::Docs.dirs(@memo_dir)
        end

        actual = @dir_set.to_a.sort.join("\n") << "\n"

        assert_equal actual, out
      end
    end

    # TODO: to_filesからfilesのテストコードにする
    describe '#to_files' do
      it "memo_dirのファイルの一覧とそのファイルが属しているディレクトリを表示する" do
        expected = @test_entries
          .group_by(&:dir)
          .map do |dir, entries|
            filenames = entries.map { |entry| File.basename(entry.full_path, '.md') }.sort
            [Rainbow(dir).green, filenames]
          end

        actual = Memo::Docs.new(@memo_dir).to_files
          .map { |dir, filenames| [dir, filenames.sort] }

        assert_equal expected.sort, actual.sort
      end
    end

    describe '#files_by_dir' do
      it "memo_dirの中に存在するdirを受け取った場合は、そのディレクトリの中にあるメモの配列を返す" do
        exist_dir = 'cli'

        out, = capture_io do
          Memo::Docs.files_by_dir(@memo_dir, exist_dir)
        end

        expected = @test_entries
          .filter_map { |entry| File.basename(entry.full_path, '.md') if entry.dir == exist_dir }
          .sort
          .join("\n") << "\n"

        assert_equal expected, out
      end

      it "memo_dirの中に存在しないdirを受け取った場合は、ディレクトリが見当たらない旨のメッセージを表示する" do
        invalid_dir = 'invalid'

        out, = capture_io do
          exception = assert_raises(SystemExit) do
            Memo::Docs.files_by_dir(@memo_dir, invalid_dir)
          end

          assert_equal 2, exception.status
        end

        assert_equal "#{invalid_dir}というディレクトリはありません。\n", out
      end
    end

    describe '#list' do
      it "引数が一つの場合は#filesを呼び出す" do
        skip "TODO"
      end

      it "引数が二つの場合は#files_by_dirを呼び出す" do
        skip "TODO"
      end
    end
  end
end

# frozen_string_literal: true

require_relative "../test_helper"

class TestDocs < Minitest::Test
  describe 'Docs' do
    include MemoTestLifecycleHooks

    describe '#initialize' do
      describe '@entries' do
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

          # dir: が"."の場合と、filenameがREADME.mdの場合が面倒
          # TODO: このような条件分岐はテストコードにも反映させた方が良さそう
          assert_equal @test_entries.to_set, entries.to_set
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

    describe '#to_files' do
      it "memo_dirのファイルの一覧とそのファイルが属しているディレクトリを表示する" do
        expected = @test_to_files

        actual = Memo::Docs.new(@memo_dir).to_files

        # 順番が異なっていても、書き出す内容が同じなら問題ない
        # 一次元の配列にしてsortすれば同じ内容になる
        assert_equal expected.flatten.sort, actual.flatten.sort
      end
    end

    describe '#files_by_dir' do
      it "memo_dirの中に存在するdirを受け取った場合は、そのディレクトリの中にあるメモの配列を返す" do
        exist_dir = 'cli'

        out, = capture_io do
          Memo::Docs.files_by_dir(@memo_dir, exist_dir)
        end

        expected = @test_entries
          .filter_map { |entry| entry.filename if entry.dir == exist_dir }
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
  end
end

# frozen_string_literal: true

require_relative "../test_helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
    include MemoTestLifecycleHooks

    ###
    # テストデータだとDocsの方でデータを作成してしまうため、テストに失敗してしまう。
    # 1c1
    # <  #<data Memo::Docs::Entry full_path="/var/folders/lg/wtp42wtx66nf0d87br2jwzf00000gn/T/d20260718-56814-5cqnm3/memo/cli/find.md"
    # ---
    # >  #<data Memo::Repository::Entry full_path="/var/folders/lg/wtp42wtx66nf0d87br2jwzf00000gn/T/d20260718-56814-5cqnm3/memo/cli/find.md"
    describe '#initialize' do
      it 'Repository.new()' do
        expected = Memo::Repository.new(@memo_dir).to_set

        _(expected).must_equal(@test_repository_entries.to_set)
      end
    end

    describe '#find' do
      it "memoの中に存在するファイルが見つかった場合は、そのファイルのEntryの配列を返す" do
        word = 'find'
        expected = Memo::Repository.new(@memo_dir).find(word)
        actual = Memo::Repository::Entry.new(full_path: File.join(@memo_dir, "cli", "find.md"), filename: "find", dir: "cli")

        assert_equal actual, expected
      end

      it "memoの中に存在しないwordが入力された場合は、nilを返す" do
        word = 'invalid_word'
        expected = Memo::Repository.new(@memo_dir).find(word)

        assert_nil expected
      end

      it "wordがnilの場合も、nilを返す" do
        word = nil
        expected = Memo::Repository.new(@memo_dir).find(word)

        assert_nil expected
      end
    end

    describe '#read' do
      it "entryが存在すれば、そのファイルを全文表示する。、" do
        expected_entry = @test_repository_entries.find { |entry| entry.filename == "find" }
        Memo::Repository.new(@memo_dir)
        expected = Memo::Repository.read(expected_entry)

        actual = MemoTestLifecycleHooks::TEST_FIND_FILE_CONTENT.split("\n")

        assert_equal actual, expected
      end

      it "nilが与えられたら、そのままnilを返す" do
        Memo::Repository.new(@memo_dir)
        expected = Memo::Repository.read(nil)

        assert_nil expected
      end
    end

    describe '#files_grouped_by_dir' do
      it "ディレクトリの文字列をキーで、値がそのディレクトリに所属するファイル名の配列であるHashを返す" do
        expected = Memo::Repository.new(@memo_dir).files_grouped_by_dir

        _(expected).must_equal(@test_repository_grouped_files)
      end
    end

    describe '#grouped_file_list' do
      it "Structを返す" do
        expected = Memo::Repository.new(@memo_dir).grouped_file_list

        actual = @test_repository_entries.group_by(&:dir).map do |dir, entry|
          Memo::GroupedFileList.new(
            dir: dir,
            filenames: entry.map(&:filename).sort
          )
        end

        _(actual).must_equal(expected)
      end
    end
  end
end

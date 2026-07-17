# frozen_string_literal: true

require_relative "../test_helper"

class TestMemoFileUtility < Minitest::Test
  describe '#filename' do
    it "絶対パスを取ったら、そのファイルの.mdをとったファイル名を返す" do
      expected = Memo::MemoFileUtility.filename(File.join(Dir.home, "/repo/memorandum/memo/", "foo.md"))

      _(expected).must_equal("foo")
    end

    it "半端なパスでも、そのファイルの.mdをとったファイル名を返す" do
      expected = Memo::MemoFileUtility.filename(File.join("/repo/memorandum/memo/", "foo.md"))

      _(expected).must_equal("foo")
    end

    it "相対パスでも、そのファイルの.mdをとったファイル名を返す" do
      expected = Memo::MemoFileUtility.filename(File.join("./memorandum/memo/", "foo.md"))

      _(expected).must_equal("foo")
    end
  end

  describe '#to_dirs' do
    include MemoTestLifecycleHooks

    it "集合を引数にとったら、その配列を返すだけ" do
      expected = Memo::MemoFileUtility.to_dirs(@dir_set)

      _(expected).must_equal(@dir_set.to_a)
    end
  end
end

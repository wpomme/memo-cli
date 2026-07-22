# frozen_string_literal: true

require_relative "../test_helper"

class TestFileUtility < Minitest::Test
  describe '#MemoTestLifecycleHooks' do
    describe '#filename' do
      include Memo::FileUtility

      it "絶対パスを取ったら、そのファイルの.mdをとったファイル名を返す" do
        expected = filename(File.join(Dir.home, "/repo/memorandum/memo/", "foo.md"))

        _(expected).must_equal("foo")
      end

      it "半端なパスでも、そのファイルの.mdをとったファイル名を返す" do
        expected = filename(File.join("/repo/memorandum/memo/", "foo.md"))

        _(expected).must_equal("foo")
      end

      it "相対パスでも、そのファイルの.mdをとったファイル名を返す" do
        expected = filename(File.join("./memorandum/memo/", "foo.md"))

        _(expected).must_equal("foo")
      end
    end

    describe '#grouped_by_dir' do
      include Memo::FileUtility
      include MemoTestLifecycleHooks

      it "Seedの配列をとったら、そのキーがディレクトリの一覧となるハッシュを返す" do
        expected = grouped_by_dir(@test_repository_entries)

        _(expected.keys.to_set).must_equal(@dir_set)
      end

      # とりあえず、ファイル名だけが入っていることを確かめれば良い
      # 実装の方のgrouped_by_dir()はREADME.mdが除外されるようにしてある
      it "ディレクトリごとのキーの値は、値データのSeedで絶対パスやファイル名などの情報が入っている" do
        actual = MemoTestLifecycleHooks::TEST_MEMO_DATA_SEED
          .filter { |elem| elem[:filename] != "README.md" }
          .group_by { |elem| elem[:dir] }
          .to_set do |k, v|
            { k => v.to_set { |elem| filename(elem[:filename]) } }
          end

        expected = grouped_by_dir(@test_repository_entries).to_set do |k, v|
          { k => v.to_set(&:filename) }
        end

        _(expected).must_equal(actual)
      end
    end
  end
end

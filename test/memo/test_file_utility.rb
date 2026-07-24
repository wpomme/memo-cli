# frozen_string_literal: true

require_relative "../helper"

class TestFileUtility < Minitest::Test
  describe '#TestFileUtility' do
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
  end
end

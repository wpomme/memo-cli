# frozen_string_literal: true

require_relative "../helper"

class TestModel < Minitest::Test
  describe 'Model' do
    include MemoTestLifecycleHooks
    include Memo::Model

    describe '#grouped_file_list' do
      it "Structを返す" do
        expected = grouped_file_list(@test_seeds)

        actual = @test_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename)
          )
        end

        _(actual).must_equal(expected)
      end
    end

    describe '#search' do
      it '読み込んだファイルの中に該当の文字列が含まれていれば、GrepLineの配列を返す' do
        skip("TODO: 特定のモックデータが欲しい")
      end
    end
  end
end

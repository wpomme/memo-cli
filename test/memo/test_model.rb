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
  end
end

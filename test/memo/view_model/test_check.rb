# frozen_string_literal: true

require_relative '../../helper'

class TestViewModelCheck < Minitest::Test
  describe 'ViewModel::Check' do
    include MemoLifecycleHooks
    include Memo::ViewModel

    def setup
      super
      @vm = Memo::ViewModel::Check.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe 'Checkクラス' do
      it 'CheckはMemo::ViewModelをインクルードしていること' do
        actual = Memo::ViewModel::Check.include?(Memo::ViewModel)

        _(actual).must_equal(true)
      end
    end

    describe '#execute' do
      it '重複するファイル名のファイルが含まれていること' do
        actual = @vm.execute

        _(actual).must_include(@fixed_duplicated_filename)
      end

      it '重複するファイル名について、そのディレクトリ名が含まれていること' do
        ret = @vm.execute

        dup_seeds = @file_loader.duplicated_seeds

        actual = dup_seeds.all? do |mock_seed|
          ret.include?(mock_seed[:parent_directory])
        end

        _(actual).must_equal(true)
      end
    end
  end
end

# frozen_string_literal: true

require_relative '../../helper'

class TestViewDirs < Minitest::Test
  describe 'ViewModel::Dirs' do
    include MemoLifecycleHooks
    include Memo::ViewModel

    def setup
      super
      @view = Memo::ViewModel::Dirs.new(target_dirs: @test_target_dirs)
      @directory_loader = Memo::DirectoryLoader.new(target_dirs: @test_target_dirs)
    end

    it 'Memo::ViewModelをインクルードしていること' do
      actual = Memo::ViewModel::Dirs.include?(Memo::ViewModel)

      _(actual).must_equal(true)
    end

    describe '#execute' do
      it '対象ディレクトリが色付けされた文字列として出力されること' do
        ret = @view.execute

        act_set = ret.split("\n").to_set

        exp_set = @test_target_dirs.map.to_set do |target_dir|
          dir_color_main(target_dir)
        end

        actual = exp_set.subset?(act_set)

        _(actual).must_equal(true)
      end

      it 'ディレクトリの一覧が相対パスとして出力されること' do
        ret = @view.execute

        act_set = ret.split("\n").to_set

        exp_set = @directory_loader.directory_seeds.map.to_set { |dir_seed| dir_seed[:relative_path] }

        actual = exp_set - act_set

        _(actual).must_equal(Set.new)
      end
    end
  end
end

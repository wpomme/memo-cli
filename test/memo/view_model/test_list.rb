# frozen_string_literal: true

require_relative '../../helper'

class TestViewList < Minitest::Test
  describe 'ViewModel::List' do
    include MemoLifecycleHooks
    include Memo::ViewModel

    def setup
      super
      @vm = Memo::ViewModel::List.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
      @directory_loader = Memo::DirectoryLoader.new(target_dirs: @test_target_dirs)
    end

    describe 'Listクラス' do
      it 'ListはMemo::ViewModelをインクルードしていること' do
        actual = Memo::ViewModel::List.include?(Memo::ViewModel)

        _(actual).must_equal(true)
      end
    end

    describe '#execute' do
      it '引数がtrueの場合、対象のディレクトリの配列が返ってくる' do
        actual = @vm.execute(true)

        _(actual).must_be_instance_of(Array)
      end

      it '引数がtrueの場合、対象のディレクトリの配列が返ってきて、その中に色付けされたディレクトリの一覧があること' do
        result = @vm.execute(true)

        result_set = Set.new(result)

        colored_dir_set = Set.new

        @file_loader.file_seeds.each do |file_seed|
          pd = file_seed[:parent_directory]
          rel_dir = @directory_loader.to_relative_dir[pd]
          colored_dir_set.add(dir_color_sub(rel_dir))
        end

        colored_target_dir_set = Set.new

        @test_target_dirs.each do |target_dir|
          colored_target_dir_set.add(dir_color_main(target_dir))
        end

        empty_set = Set.new

        _(colored_dir_set - result_set).must_equal(empty_set)
        _(colored_target_dir_set - result_set).must_equal(empty_set)

        _(result).must_be_instance_of(Array)
      end

      it '有効な引数を取る場合、対象のディレクトリの配列が返ってくる' do
        dirname = 'git/'

        actual = @vm.execute(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '末尾のスラッシュを付けなくても、対象のディレクトリの配列が返ってくる' do
        dirname = 'git'

        actual = @vm.execute(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '有効な引数を取る場合、対象のディレクトリの配列が返ってくる' do
        dirname = 'lang/'

        actual = @vm.execute(dirname)

        _(actual).must_be_instance_of(Array)
      end

      it '無効な引数を取る場合、nilが返ってくる。後ほどメッセージが返ってくるように修正する' do
        dirname = 'does_not_exist_dirname'

        actual = @vm.execute(dirname)

        _(actual).must_be_nil
      end
    end
  end
end

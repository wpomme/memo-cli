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

    describe '#default' do
      it '対象ディレクトリ、ファイルが入っている親ディレクトリ、そのディレクトリの中のファイル名一覧が表示されること' do
        act_set = Set.new

        @vm.default.split("\n").each do |line|
          next if /\A\s*\Z/.match?(line)

          # カラーコードの付いている文字列を抜き出す
          if /\A\e\[3/.match?(line)
            # Rainbow.uncolorでカラーコードを取り除ける
            uncolored = Rainbow.uncolor(line)
            act_set.add(uncolored)
          else
            line.split do |filename|
              act_set.add(filename)
            end
          end
        end

        exp_set = Set.new

        @file_loader.grouped_seeds.each do |target_dir, hash_seed|
          exp_set.add(target_dir)
          hash_seed.each do |parent_dir, seeds|
            exp_set.add(parent_dir)
            seeds.map do |s|
              exp_set.add(s[:filename])
            end
          end
        end

        _(act_set - exp_set).must_equal(Set.new)
      end
    end

    describe('#directory') do
      it '有効な引数を取った場合、そのディレクトリと、その中のファイル名一覧と、対象のディレクトリを含む文字列が返ってくること' do
        dirname = @test_mock_dir

        target_dir = @test_mock_target_dir
        filenames = @file_loader.file_seeds.filter { |seed| seed[:parent_directory] == dirname }
          .map { |seed| seed[:filename] }

        ret = @vm.directory(dirname)

        actual = [target_dir, dirname].concat(filenames).all? do |elem|
          ret.include?(elem)
        end

        _(actual).must_equal(true)
      end

      # TODO: 入力値に関するテストコードを作成する
      # 有効値: 末尾のスラッシュの有無・ディレクトリの一覧を全て入力値として入れてみる

      it 'file_seedsの相対パスに含まれているディレクトリなら、ディレクトリ名などが返ってくる' do
        dirnames = @file_loader.file_seeds.map do |seed|
          seed[:relative_path]
        end.uniq

        actual = dirnames.any? do |dirname|
          @vm.directory(dirname).include?(Memo::Message::NO_FILES_IN_THE_DIR.gsub('dir', dirname))
        end

        _(actual).must_equal(false)
      end

      it '無効な引数を取る場合、そのようなディレクトリがないことを示す文字列を返すこと' do
        dirname = 'does_not_exist_dirname'

        actual = @vm.directory(dirname)

        _(actual).must_equal(Memo::Message::NO_DIRECTORIES.gsub('dir', dirname))
      end
    end
  end
end

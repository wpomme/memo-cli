# frozen_string_literal: true

require_relative '../../helper'

class TestViewTags < Minitest::Test
  describe 'ViewModel::Tags' do
    include MemoLifecycleHooks
    include Memo::ViewModel

    def setup
      super
      @vm = Memo::ViewModel::Tags.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe 'Tagsクラス' do
      it 'TagsはMemo::ViewModelをインクルードしていること' do
        actual = Memo::ViewModel::Tags.include?(Memo::ViewModel)

        _(actual).must_equal(true)
      end
    end

    describe '#execute' do
      it '全てのタグ名とそのタグが付いたファイルの数に色を付けて出力すること' do
        actual = @vm.default.split("\n").filter do |line|
          /.+: \d+/.match(line)
        end

        tag_file_size_hash = @file_loader.tag_files_hash.transform_values(&:size)
        expected = tag_file_size_hash.map do |tag, file_size|
          tag_color("#{tag}: #{file_size}")
        end

        _(actual).must_equal(expected)
      end

      it 'タグに紐付いたファイル名の一覧を全て出力すること' do
        act_set = @vm.default.split("\n").reject do |line|
          /.+: \d+/.match(line) || ''.match(line)
        end.to_set

        exp_set = @file_loader.tag_files_hash.values.to_set do |value|
          value.join(Memo::ViewModel::SPACE)
        end

        _(act_set - exp_set).must_equal(Set.new)
      end
    end

    describe '#name' do
      it '辞書式順に整列されたタグ名の一覧が出力されること' do
        actual = @vm.name

        expected = @file_loader.tags_sorted_by_tag_name

        _(actual).must_equal(expected)
      end
    end

    describe '#count' do
      it 'タグ名とそのタグが付いたファイルの数を出力すること' do
        actual = @vm.count

        expected = @file_loader.tags_sorted_by_file_size.map do |k, v|
          ["#{k}: #{v}"]
        end

        _(actual).must_equal(expected)
      end
    end

    describe '#empty' do
      it 'タグの付いていないファイル名の一覧を出力する。全てのファイルにタグが付いていれば、ユーザーメッセージを表示する。' do
        skip 'TODO'
        # actual = out.size
        #
        # expected = Memo::FileLoader.new.tag_size

        # _(actual).must_equal(expected)
      end
    end
  end
end

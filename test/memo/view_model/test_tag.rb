# frozen_string_literal: true

require_relative '../../helper'

class TestViewTag < Minitest::Test
  describe 'ViewModel::Tag' do
    include MemoLifecycleHooks
    include Memo::ViewModel

    def setup
      super
      @vm = Memo::ViewModel::Tag.new(target_dirs: @test_target_dirs)
      @file_loader = Memo::FileLoader.new(target_dirs: @test_target_dirs)
    end

    describe '#execute' do
      describe 'タグが見つかった場合、' do
        word = 'CLI'

        it 'タグ名とそのタグが付いたファイルの数に色を付けて出力すること' do
          actual = @vm.execute(word).split("\n").first

          file_size = @file_loader.tag_files_hash[word].size
          expected = tag_color("#{word}: #{file_size}")

          _(actual).must_equal(expected)
        end

        it 'そのタグに紐付いたファイル名を出力すること' do
          act_set = @vm.execute(word).split("\n").last.split(Memo::ViewModel::SPACE).to_set

          exp_set = @file_loader.tag_files_hash[word].to_set

          _(act_set - exp_set).must_equal(Set.new)
        end
      end

      it '見つからなかった場合、その旨を示すエラーメッセージを表示すること' do
        word = 'does_not_exist_words'
        tag_list = @file_loader.tags_sorted_by_tag_name.join(Memo::ViewModel::SPACE)

        actual = @vm.execute(word)

        expected = Memo::Message::NO_TAGS.sub('tag', word) << tag_list

        _(actual).must_equal(expected)
      end
    end
  end
end

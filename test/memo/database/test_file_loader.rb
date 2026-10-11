# frozen_string_literal: true

require_relative '../../helper'

class TestFileLoader < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('DB::FileLoader') do
    describe('#load_files_called?') do
      it('メソッドを同時に呼んでも、#load_fileは一回だけしか呼ばれないこと') do
        file_loader = Memo::Database::FileLoader.new

        file_loader.file_hash_seeds
        file_loader.file_path_tags_hash
        file_loader.all_tags

        actual = file_loader.instance_variable_get(:@method_called_count)

        expected = 1

        _(actual).must_equal(expected)
      end
    end

    describe('#file_hash_seeds') do
      it('Fileテーブルを作成するのに必要なハッシュが入った一次元配列が返されること') do
        file_hash_seeds = Memo::Database::FileLoader.new.file_hash_seeds

        actual = file_hash_seeds.all? do |file_hash|
          FileTest.file?(file_hash[:absolute_path]) &&
            FileTest.directory?(file_hash[:parent_directory]) &&
            file_hash[:file_content].instance_of?(String)
        end

        _(actual).must_equal(true)
      end
    end

    describe('#file_path_tags_hash') do
      it('TagとFileTagテーブルを作成するのに必要なハッシュ値が返されること') do
        file_path_tags_hash = Memo::Database::FileLoader.new.file_path_tags_hash

        actual = file_path_tags_hash.all? do |(path, tags)|
          FileTest.file?(path) && tags.all?(String)
        end

        _(actual).must_equal(true)
      end
    end

    describe('#all_tags') do
      it('Tagテーブルを作成するのに必要なタグ名の配列が返されること') do
        all_tags = Memo::Database::FileLoader.new.all_tags

        actual = all_tags.all?(String)

        _(actual).must_equal(true)
      end
    end

    describe('#all_tag_count_of_appearance') do
      it('整数が返されること') do
        actual = Memo::Database::FileLoader.new.all_tag_count_of_appearance

        _(actual).must_be_instance_of(Integer)
      end
    end
  end
end

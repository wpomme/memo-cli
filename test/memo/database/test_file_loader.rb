# frozen_string_literal: true

require_relative '../../helper'

class TestFileLoader < Minitest::Test
  include MemoDBTestLifecycleHooks

  describe('DB::FileLoader') do
    describe('#load_files_called?') do
      it('メソッドを同時に呼んでも、#load_fileは一回だけしか呼ばれないこと') do
        skip 'TODO: Minitestのモックを探す。なければRSpecに移行する'
        file_loader = Memo::Database::FileLoader.new

        file_loader.file_seeds_hash
        file_loader.sorted_tags

        mock.verify

        # expected = 1

        # _(actual).must_equal(expected)
      end
    end

    describe('#file_seeds_hash') do
      it('対象のディレクトリをキーとし、そのディレクトリ内のファイルに関するハッシュが値となること') do
        file_loader = Memo::Database::FileLoader.new
        file_seeds_hash = file_loader.file_seeds_hash

        file_seeds_hash.all? do |target_dir, file_seeds|
          FileTest.directory?(target_dir) &&
            file_seeds.all? do |file_seed|
              FileTest.file?(file_seed[:absolute_path]) &&
                FileTest.directory?(file_seed[:parent_directory]) &&
                file_seed[:file_content].instance_of?(String)
            end
        end
      end
    end

    describe('#sorted_tags') do
      it('Tagテーブルを作成するのに必要なタグ名の配列が返されること') do
        sorted_tags = Memo::Database::FileLoader.new.sorted_tags

        actual = sorted_tags.all?(String)

        _(actual).must_equal(true)
      end
    end

    describe('#tag_size') do
      it('整数が返されること') do
        actual = Memo::Database::FileLoader.new.tag_size

        _(actual).must_be_instance_of(Integer)
      end
    end

    describe('#total_tag_size') do
      it('整数が返されること') do
        actual = Memo::Database::FileLoader.new.total_tag_size

        _(actual).must_be_instance_of(Integer)
      end
    end
  end
end

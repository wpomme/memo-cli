# frozen_string_literal: true

require_relative "../test_helper"

class TestMapper < Minitest::Test
  describe 'Mapper' do
    # include MemoTestLifecycleHooks

    before do
      def to_seed(base_dir, join_dir, filename)
        full_path = join_dir == "memo" ? File.join(base_dir, filename) : File.join(base_dir, join_dir, filename)
        Memo::Model::Seed.new(full_path: full_path, filename: File.basename(full_path, '.md'), dir: join_dir)
      end

      @tmpdir = Dir.mktmpdir
      @memo_dir = Memo::Env.memo_dir(File.join(@tmpdir, "memo").freeze)

      Memo::MockSeed::TEST_MEMO_DATA_SEED.each do |elem|
        dir_for_file = File.join(@memo_dir, elem[:dir])
        FileUtils.mkdir_p(dir_for_file) unless FileTest.directory?(dir_for_file)

        File.write(File.join(@memo_dir, elem[:dir], elem[:filename]), elem[:content])
      end

      @test_seeds = Memo::Repository.new.seeds

      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
    end

    after do
      Dir.chdir(@original_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    describe '#file_list_to_view' do
      # ディレクトリを緑色にするなど
      it "グループ化されたファイル名の一覧をViewで表示しやすくする" do
        expected = Memo::Mapper.file_list_to_view

        # seeds.group_by(&:dir)はFileUtility.seeds_grouped_by_dirと同じ
        grouped_file_list = @test_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename).sort
          )
        end

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end.flatten

        actual.pop

        _(actual).must_equal(expected)
      end

      it "有効なディレクトリ名を受け取った場合は、そのディレクトリとその中のファイル名を表示する" do
        valid_dir = 'cli'
        expected = Memo::Mapper.file_list_to_view(valid_dir)

        grouped_file_list = @test_seeds.group_by(&:dir).filter_map do |dir, seed|
          if dir == valid_dir
            Memo::Model::GroupedFileList.new(
              dir: dir,
              filenames: seed.map(&:filename).sort
            )
          end
        end

        actual = grouped_file_list
          .map do |struct|
            [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
          end.flatten

        actual.pop

        _(actual).must_equal(expected)
      end

      it "存在しないディレクトリ名を受け取った場合は、その旨を知らせる文字列を返す" do
        invalid_dir = 'invalid_dir'
        expected = Memo::Mapper.file_list_to_view(invalid_dir)

        # TODO: とりあえず文字列を返すことだけを確認する
        assert expected.is_a?(String)
      end
    end
  end
end

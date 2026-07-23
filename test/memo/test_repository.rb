# frozen_string_literal: true

require_relative "../test_helper"

class TestRepository < Minitest::Test
  describe 'Repository' do
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

      @repo = Memo::Repository.new
      @test_seeds = @repo.seeds
      @dir_set =  @repo.dir_set

      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
    end

    after do
      Dir.chdir(@original_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    describe '#initialize' do
      it '@seedsはMemo::Model::SeedのArrayである' do
        # repo = Memo::Repository.new
        seeds = @repo.instance_variable_get(:@seeds)

        assert_instance_of Array, seeds
        seeds.each do |seed|
          assert_instance_of Memo::Model::Seed, seed
        end
      end

      it '@seeds.full_pathはREADME(.md) を含まない' do
        # repo = Memo::Repository.new
        seeds = @repo.instance_variable_get(:@seeds)
        full_path = seeds.map(&:full_path)

        refute_includes full_path, "README"
        refute_includes full_path, "README.md"
      end

      # これが成り立たないとmemo readが出来ない
      # ただ、どちらかといえば、memoフォルダの設定ミスのために生じる不具合のような
      it '@seeds:full_path は絶対パスである' do
        # repo = Memo::Repository.new
        seeds = @repo.instance_variable_get(:@seeds)
        full_paths = seeds.map(&:full_path)

        full_paths.each do |full_path|
          assert File.absolute_path?(full_path)
        end
      end
    end

    describe '#find' do
      it "memoの中に存在するファイルが見つかった場合は、そのファイルのSeedの配列を返す" do
        word = 'push'
        # repo = Memo::Repository.new
        expected = @repo.find(word)
        actual = @test_seeds.find { |seed| seed.filename == word }
        # actual = Memo::Model::Seed.new(full_path: File.join(@memo_dir, "git", "push.md"), filename: "push", dir: "git")

        assert_equal expected, actual
      end

      it "memoの中に存在しないwordが入力された場合は、nilを返す" do
        word = 'invalid_word'
        expected = @repo.find(word)

        assert_nil expected
      end

      it "wordがnilの場合も、nilを返す" do
        word = nil
        expected = @repo.find(word)

        assert_nil expected
      end
    end

    describe '#read' do
      it "seedが存在すれば、そのファイルを全文表示する。、" do
        expected_seed = @test_seeds.find { |seed| seed.filename == "push" }
        expected = @repo.read(expected_seed)

        actual = Memo::MockSeed::TEST_PUSH_FILE_CONTENT

        assert_equal expected, actual.split("\n") << ""
      end

      it "nilが与えられたら、そのままnilを返す" do
        expected = @repo.read(nil)

        assert_nil expected
      end
    end

    describe '#grouped_file_list' do
      it "Structを返す" do
        expected = @repo.grouped_file_list

        actual = @test_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename).sort
          )
        end

        _(actual).must_equal(expected)
      end
    end
  end
end

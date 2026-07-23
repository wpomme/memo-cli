# frozen_string_literal: true

require_relative "../test_helper"
require_relative "../mock_seeds"

class TestModel < Minitest::Test
  describe 'Model' do
    include Memo::MockSeed
    include Memo::Env

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

    describe '#grouped_file_list' do
      it "Structを返す" do
        expected = Memo::Model.new.grouped_file_list(@test_seeds)

        actual = @test_seeds.group_by(&:dir).map do |dir, seed|
          Memo::Model::GroupedFileList.new(
            dir: dir,
            filenames: seed.map(&:filename)
          )
        end

        _(actual).must_equal(expected)
      end
    end
  end
end

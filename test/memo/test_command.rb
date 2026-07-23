# frozen_string_literal: true

require_relative "../test_helper"

class TestCommand < Minitest::Test
  describe 'Command' do
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

      repo = Memo::Repository.new
      @test_seeds = repo.seeds
      @dir_set =  repo.dir_set

      @original_dir = Dir.pwd
      Dir.chdir(@tmpdir)
    end

    after do
      Dir.chdir(@original_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    describe '#execute' do
      describe 'args: dirs' do
        it "['dirs']を受け取ったときは、memo_dirの中のディレクトリの一覧を標準出力に表示する" do
          out, = capture_io do
            Memo::Command.new.execute(['dirs'])
          end

          actual = @dir_set
          assert_equal actual, out.split("\n").to_set
        end
      end

      describe 'args: list' do
        it "['list']を受け取ったときは、memo_dirの中のディレクトリとその中にあるメモファイルを全て表示する" do
          out, = capture_io do
            Memo::Command.new.execute(['list'])
          end

          # TODO: RepositoryからCommandにまで渡るここら辺の処理をまとめたい
          # seeds.group_by(&:dir)はFileUtility.seeds_grouped_by_dirと同じ
          grouped_file_list = @test_seeds.group_by(&:dir).map do |dir, seed|
            Memo::Model::GroupedFileList.new(
              dir: dir,
              filenames: seed.map(&:filename).sort
            )
          end

          file_test_to_view = grouped_file_list
            .map do |struct|
              [Rainbow(struct[:dir]).green].append(struct[:filenames], "\n")
            end

          # 表示される文字列が同じなら順番は関係がない
          # 集合にして同じ文字列があればよし
          actual = file_test_to_view.flatten.to_set

          # 改行で配列を作成するが、改行自身は集合に加える必要がある
          expected = out.split("\n").to_set.add("\n")
          # ユーザーに表示される票は空行が入っているので、それを取り除く
          expected.delete("")

          _(expected).must_equal(actual)
        end

        it "['list', 'cli']を受け取ったときは、memo_dirの中のcliディレクトリの中にあるメモファイルを全て表示する" do
          valid_dir = 'cli'

          out, = capture_io do
            Memo::Command.new.execute(['list', valid_dir])
          end

          grouped_file_list = @test_seeds.group_by(&:dir).filter_map do |dir, seed|
            if dir == valid_dir
              Memo::Model::GroupedFileList.new(
                dir: dir,
                filenames: seed.map(&:filename).sort
              )
            end
          end

          # FIXME: 実装の方で、最後の方に余計な改行が入っているので、修正すること
          actual = grouped_file_list
            .map do |struct|
              [Rainbow(struct[:dir]).green].append(struct[:filenames])
            end.flatten.join("\n") << "\n"

          _(actual).must_equal(out)
        end

        it "['list', 'invalid_dir']の場合、ユーザーメッセージ" do
          skip "TODO"
        end
      end

      describe 'args: read' do
        it "['read', 'push']を受け取ったときは、push.mdを全文表示する" do
          out, = capture_io do
            Memo::Command.new.execute(%w[read push])
          end

          assert_equal Memo::MockSeed::TEST_PUSH_FILE_CONTENT, out
        end

        it "['read', 'invalid_memo']を受け取ったときは、そのようなメモがないことを表示する" do
          word = 'invalid_memo'

          out, = capture_io do
            exception = assert_raises(SystemExit) do
              Memo::Command.new.execute(%w[read invalid_memo])
            end

            assert_equal 2, exception.status
          end

          assert_equal "#{word} というメモは見つかりませんでした。\n", out
        end

        # Memo::Command以下のParserの動作みたい
        it "['read', nil]を受け取ったときは、例外を送出する" do
          word = nil

          capture_io do
            exception = assert_raises(OptionParser::InvalidArgument) do
              Memo::Command.new.execute(['read', word])
            end

            assert_equal "invalid argument: -r ", exception.message
          end
        end
      end
    end
  end
end

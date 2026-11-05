# frozen_string_literal: true

class TestSubCommandParser < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe '#execute' do
    def setup
      @scp = Memo::SubCommandParser.new
    end

    describe 'SubCommandParserクラス' do
      it 'SubCommandParserはMemo::Messageをインクルードしていること' do
        actual = Memo::SubCommandParser.include?(Memo::Message)

        _(actual).must_equal(true)
      end

      it 'SubCommandParserはMemo::HelpMessageをインクルードしていること' do
        actual = Memo::SubCommandParser.include?(Memo::HelpMessage)

        _(actual).must_equal(true)
      end
    end

    describe '引数による分類' do
      it '引数がない場合はヘルプメッセージを表示する' do
        skip 'TODO'
      end

      describe '第一引数がサブコマンドではない場合' do
        it 'readコマンドとして解釈する' do
          argv = %w[foo]

          actual = @scp.execute(argv)

          _(actual).must_equal({ 'read' => 'foo' })
        end

        it '第二引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO'
        end
      end
    end

    describe 'サブコマンドによる分類' do
      describe '#parse_one_argument: read, search, tag' do
        it '引数が存在しない場合は、エラーメッセージを表示する' do
          args = %w[read search tag]

          args.each do |arg|
            actual, = capture_io do
              exception = assert_raises(SystemExit) do
                @scp.execute([arg])
              end

              _(exception.status).must_equal(2)
            end

            expected = NO_GIVEN_ARGS.gsub('CLI', arg)

            _(actual).must_equal(expected)
          end
        end

        it '文字列をファイル名やタグ名として解釈できる' do
          arg1 = %w[read search tag]

          arg2 = 'foo'

          arg1.each do |arg|
            actual = @scp.execute([arg, arg2])

            _(actual).must_equal({ arg => arg2 })
          end
        end

        it '引数が二つ存在する場合は、エラーメッセージを表示する' do
          arg1 = %w[read search tag]

          arg2 = 'foo'
          arg3 = 'bar'

          arg1.each do |arg|
            actual, = capture_io do
              exception = assert_raises(SystemExit) do
                @scp.execute([arg, arg2, arg3])
              end

              _(exception.status).must_equal(2)
            end

            expected = TOO_MANY_ARGS.gsub('CLI', arg)

            _(actual).must_equal(expected)
          end
        end
      end

      describe '#parse_no_arguments: dirs, version' do
        it '引数を取らない場合は、dirs: nilを返す' do
          argv = %w[dirs]

          actual = @scp.execute(argv)

          _(actual).must_equal({ 'dirs' => nil })
        end

        it '引数がある場合は、エラーメッセージを表示する' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              argv = %w[dirs foo]

              @scp.execute(argv)
            end

            _(exception.status).must_equal(2)
          end

          expected = TOO_MANY_ARGS.gsub('CLI', 'dirs')

          _(actual).must_equal(expected)
        end

        describe 'version' do
          it '"version", "-V"でバージョンを出力し、正常終了する' do
            args = %w[version -V]

            expected = { 'version' => nil }

            args.each do |arg|
              actual = @scp.execute([arg])

              _(actual).must_equal(expected)
            end
          end
        end
      end

      describe 'tags' do
        it 'tagsのみの場合は、tags: trueを返す' do
          argv = %w[tags]

          actual = @scp.execute(argv)

          _(actual).must_equal({ 'tags' => true })
        end

        it '特定のオプションを受け取った場合は、それに対応するシンボルを返す' do
          argv = 'tags'
          option_hash = {
            '-e' => :empty,
            '--empty' => :empty,
            '-c' => :count,
            '--count' => :count,
            '-n' => :name,
            '--name' => :name
          }

          args_arr = option_hash.keys.map { |opt| [argv, opt] }

          args_arr.each do |args|
            actual = @scp.execute(args)
            _(actual).must_equal({ argv => option_hash[args.last] })
          end
        end

        it 'memo tags -hの場合' do
          skip 'TODO: ヘルプメッセージを表示する'
          argv = 'tags'
          options = ['-h', '--help']

          args = options.map { |opt| [argv, opt] }

          args.each do |arg|
            actual = @scp.execute(arg)
            _(actual).must_equal({ argv => :name })
          end
        end

        it '登録されていないオプションが入力された場合は、エラーメッセージを返す' do
          skip 'TODO'
          ['-b']
        end

        # TODO: 全通りについてテストする
        it 'オプションを同時に指定した場合は、エラーを返す' do
          argv = %w[tags -nc]

          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              @scp.execute(argv)
            end

            _(exception.status).must_equal(2)
          end

          expected = TOO_MANY_OPTIONS.gsub('CLI', 'tags')

          _(actual).must_equal(expected)
        end

        it '第三引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO: OptionParserだと何もしないので、引数はスルーする'
          argv = 'tags'
          options = ['-n', '--name', '-c', '--count']
          rest_argv = 'foo'

          # exit 2を使うかも
          options.map { |opt| [argv, opt, rest_argv] }
            .map do |args|
            @scp.execute(args)
          end
        end
      end

      describe 'list' do
        it 'listのみの場合は、list: trueを返す' do
          argv = %w[list]

          actual = @scp.execute(argv)

          _(actual).must_equal({ 'list' => true })
        end

        it '特定のオプションを受け取った場合は、それに対応するシンボルを返す' do
          argv = 'list'
          option_hash = {
            '-c' => :count,
            '--count' => :count,
            '-d' => :duplicate,
            '--duplicate' => :duplicate
          }

          args_arr = option_hash.keys.map { |opt| [argv, opt] }

          args_arr.each do |args|
            actual = @scp.execute(args)
            _(actual).must_equal({ argv => option_hash[args.last] })
          end
        end

        it '引数を取る場合は、list:の値にその文字列を返す' do
          argv = %w[list foo]

          actual = @scp.execute(argv)

          _(actual).must_equal({ 'list' => 'foo' })
        end

        it '引数が32文字なら、list:の値にその文字列を返す' do
          arg1 = 'list'
          arg2 = 'あ' * 32

          actual = @scp.execute([arg1, arg2])

          _(actual).must_equal({ 'list' => arg2 })
        end

        it '引数が33文字なら、エラーメッセージを返す' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              arg1 = 'list'
              arg2 = 'あ' * 33

              @scp.execute([arg1, arg2])
            end

            _(exception.status).must_equal(2)
          end

          expected = TOO_LONG_ARGS

          _(actual).must_equal(expected)
        end
      end
    end
  end
end

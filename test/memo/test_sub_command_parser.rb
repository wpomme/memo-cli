# frozen_string_literal: true

# require_relative '../helper'

class TestSubCommandParser < Minitest::Test
  describe '#run' do
    describe '引数による分類' do
      it '引数がない場合はヘルプメッセージを表示する' do
        skip 'TODO'
      end

      describe '第一引数がサブコマンドではない場合' do
        it 'readコマンドとして解釈する' do
          skip 'TODO'
          argv = %w[foo]

          actual = Memo::SubCommandParser.run(argv)

          # 次のどちらかを返す
          _(actual).must_equal({ read: 'foo' })
        end

        it '第二引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO'
          argv = %w[foo bar]

          Memo::SubCommandParser.run(argv)
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
                Memo::SubCommandParser.run([arg])
              end

              _(exception.status).must_equal(2)
            end

            expected = Memo::Message::NO_GIVEN_ARGS.gsub('CLI', arg)

            _(actual).must_equal(expected)
          end
        end

        # TODO: FileLoaderからファイル名の一覧を取得する
        # 拡張子がつく場合や、フォルダ名がつく場合のテストも欲しい
        it '存在するファイル名なら引数として解釈できる' do
          arg1 = %w[read search tag]

          arg2 = 'foo'

          arg1.each do |arg|
            actual = Memo::SubCommandParser.run([arg, arg2])

            _(actual).must_equal({ arg.intern => arg2 })
          end
        end

        it '引数が二つ存在する場合は、エラーメッセージを表示する' do
          arg1 = %w[read search tag]

          arg2 = 'foo'
          arg3 = 'bar'

          arg1.each do |arg|
            actual, = capture_io do
              exception = assert_raises(SystemExit) do
                Memo::SubCommandParser.run([arg, arg2, arg3])
              end

              _(exception.status).must_equal(2)
            end

            expected = Memo::Message::TOO_MANY_ARGS.gsub('CLI', arg)

            _(actual).must_equal(expected)
          end
        end
      end

      describe '#parse_no_arguments: dirs' do
        it '引数を取らない場合は、dirs: trueを返す' do
          argv = %w[dirs]

          actual = Memo::SubCommandParser.run(argv)

          _(actual).must_equal({ dirs: true })
        end

        it '引数がある場合は、エラーメッセージを表示する' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              argv = %w[dirs foo]

              Memo::SubCommandParser.run(argv)
            end

            _(exception.status).must_equal(2)
          end

          expected = Memo::Message::TOO_MANY_ARGS.gsub('CLI', 'dirs')

          _(actual).must_equal(expected)
        end
      end

      # TODO: #parse_with_option_parser: tagsを作成する
      describe 'tags' do
        it 'tagsのみの場合は、tags: trueを返す' do
          argv = %w[tags]

          actual = Memo::SubCommandParser.run(argv)

          _(actual).must_equal({ tags: true })
        end

        it '-c/--countがある場合は、tags: :countを返す' do
          arg = 'tags'
          options = ['-c', '--count']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::SubCommandParser.run(arg)
            _(actual).must_equal({ tags: :count })
          end
        end

        it 'memo tags -hの場合' do
          skip 'TODO: ヘルプメッセージを表示する'
          arg = 'tags'
          options = ['-h', '--help']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::SubCommandParser.run(arg)
            _(actual).must_equal({ tags: :name })
          end
        end

        it '-n/--nameがある場合は、tags: :nameを返す' do
          arg = 'tags'
          options = ['-n', '--name']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::SubCommandParser.run(arg)
            _(actual).must_equal({ tags: :name })
          end
        end

        it '-nと-cを同時に指定した場合は、エラーを返す' do
          skip 'TODO'
          argv = %w[tags -cn]

          actual = Memo::SubCommandParser.run(argv)

          _(actual).must_equal({ tags: :name })
        end

        it '第三引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO: OptionParserだと何もしないので、引数はスルーする'
          argv = 'tags'
          options = ['-n', '--name', '-c', '--count']
          rest_argv = 'foo'

          # exit 2を使うかも
          options.map { |opt| [argv, opt, rest_argv] }
            .map do |args|
            Memo::SubCommandParser.run(args)
          end
        end
      end

      describe 'list' do
        it 'listのみの場合は、list: trueを返す' do
          argv = %w[list]

          actual = Memo::SubCommandParser.run(argv)

          _(actual).must_equal({ list: true })
        end

        it '-c/--countがある場合は、list: :countを返す' do
          arg = 'list'
          options = ['-c', '--count']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::SubCommandParser.run(arg)
            _(actual).must_equal({ list: :count })
          end
        end

        it '引数を取る場合は、list:の値にその文字列を返す' do
          argv = %w[list foo]

          actual = Memo::SubCommandParser.run(argv)

          _(actual).must_equal({ list: 'foo' })
        end

        it '引数が32文字なら、list:の値にその文字列を返す' do
          arg1 = 'list'
          arg2 = 'あ' * 32

          actual = Memo::SubCommandParser.run([arg1, arg2])

          _(actual).must_equal({ list: arg2 })
        end

        it '引数が33文字なら、エラーメッセージを返す' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              arg1 = 'list'
              arg2 = 'あ' * 33

              Memo::SubCommandParser.run([arg1, arg2])
            end

            _(exception.status).must_equal(2)
          end

          expected = Memo::Message::TOO_LONG_ARGS

          _(actual).must_equal(expected)
        end
      end

      describe 'version' do
        it '"version", "-V"でバージョンを出力し、正常終了する' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              args = %w[version -V]

              args.each do |arg|
                Memo::SubCommandParser.run([arg])
              end
            end

            _(exception.status).must_equal(0)
          end

          expected = "#{Memo::VERSION}\n"

          _(actual).must_equal(expected)
        end
      end
    end
  end
end

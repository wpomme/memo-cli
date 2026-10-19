# frozen_string_literal: true

# require_relative '../helper'

class TestNewSubCommandParser < Minitest::Test
  describe '#run' do
    describe '引数による分類' do
      it '引数がない場合はヘルプメッセージを表示する' do
        skip 'TODO'
        argv = []

        Memo::NewSubCommandParser.run(argv)
      end

      describe '第一引数がサブコマンドではない場合' do
        it 'readコマンドとして解釈する' do
          skip 'TODO'
          argv = %w[foo]

          actual = Memo::NewSubCommandParser.run(argv)

          # 次のどちらかを返す
          _(actual).must_equal({ read: 'foo' })
        end

        it '第二引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO'
          argv = %w[foo bar]

          Memo::NewSubCommandParser.run(argv)
        end
      end
    end

    describe 'サブコマンドによる分類' do
      describe 'read' do
        it '引数が存在しない場合は、エラーメッセージを表示する' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              argv = %w[read]

              Memo::NewSubCommandParser.run(argv)
            end

            _(exception.status).must_equal(2)
          end

          expected = Memo::Message::NO_GIVEN_ARGS.gsub('CLI', 'read')

          _(actual).must_equal(expected)
        end

        # TODO: FileLoaderからファイル名の一覧を取得する
        # 拡張子がつく場合や、フォルダ名がつく場合のテストも欲しい
        it '存在するファイル名なら引数として解釈できる' do
          argv = %w[read foo]

          actual = Memo::NewSubCommandParser.run(argv)

          _(actual).must_equal({ read: 'foo' })
        end

        it '第三引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO'
        end
      end

      describe 'tags' do
        it 'tagsのみの場合は、tags: trueを返す' do
          argv = %w[tags]

          actual = Memo::NewSubCommandParser.run(argv)

          _(actual).must_equal({ tags: true })
        end

        it '-c/--countがある場合は、tags: :countを返す' do
          arg = 'tags'
          options = ['-c', '--count']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::NewSubCommandParser.run(arg)
            _(actual).must_equal({ tags: :count })
          end
        end

        it 'memo tags -hの場合' do
          skip 'TODO: ヘルプメッセージを表示する'
          arg = 'tags'
          options = ['-h', '--help']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::NewSubCommandParser.run(arg)
            _(actual).must_equal({ tags: :name })
          end
        end

        it '-n/--nameがある場合は、tags: :nameを返す' do
          arg = 'tags'
          options = ['-n', '--name']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::NewSubCommandParser.run(arg)
            _(actual).must_equal({ tags: :name })
          end
        end

        it '-nと-cを同時に指定した場合は、エラーを返す' do
          skip 'TODO'
          argv = %w[tags -cn]

          actual = Memo::NewSubCommandParser.run(argv)

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
            Memo::NewSubCommandParser.run(args)
          end
        end
      end

      describe 'check' do
        it 'checkのみの場合は、check: trueを返す' do
          argv = %w[check]

          actual = Memo::NewSubCommandParser.run(argv)

          _(actual).must_equal({ check: true })
        end

        it '-d/--duplicateがある場合は、duplicate: trueを返す' do
          arg = 'check'
          options = ['-d', '--duplicate']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::NewSubCommandParser.run(arg)
            _(actual).must_equal({ check: :duplicate })
          end
        end

        it 'memo check -hの場合' do
          skip 'TODO: ヘルプメッセージを表示する'
          arg = 'check'
          options = ['-h', '--help']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::NewSubCommandParser.run(arg)
            _(actual).must_equal({ check: :name })
          end
        end

        it '-e/--emptyがある場合は、check: :emptyを返す' do
          arg = 'check'
          options = ['-e', '--empty']

          args = options.map { |opt| [arg, opt] }

          args.each do |arg|
            actual = Memo::NewSubCommandParser.run(arg)
            _(actual).must_equal({ check: :empty })
          end
        end

        it '-nと-cを同時に指定した場合は、エラーを返す' do
          skip 'TODO'
          argv = %w[check -cn]

          actual = Memo::NewSubCommandParser.run(argv)

          _(actual).must_equal({ check: :name })
        end

        it '第三引数も存在する場合は、エラーメッセージを表示する' do
          skip 'TODO: OptionParserだと何もしないので、引数はスルーする'
          argv = 'check'
          options = ['-d', '--duplicate', '-e', '--empty']
          rest_argv = 'foo'

          # exit 2を使うかも
          options.map { |opt| [argv, opt, rest_argv] }
            .map do |args|
            Memo::NewSubCommandParser.run(args)
          end
        end
      end

      describe 'dirs' do
        it '引数を取らない場合は、dirs: trueを返す' do
          argv = %w[dirs]

          actual = Memo::NewSubCommandParser.run(argv)

          _(actual).must_equal({ dirs: true })
        end

        it '第三引数がある場合は、エラーメッセージを表示する' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              argv = %w[dirs foo]

              Memo::NewSubCommandParser.run(argv)
            end

            _(exception.status).must_equal(2)
          end

          expected = Memo::Message::TOO_MANY_ARGS.gsub('CLI', 'dirs')

          _(actual).must_equal(expected)
        end
      end
    end
  end
end

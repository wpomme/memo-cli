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
      describe 'list' do
        it 'listのみの場合は、list: trueを返す' do
          argv = %w[list]

          actual = @scp.execute(argv)

          _(actual).must_equal({ 'list' => true })
        end

        it '特定のオプションを受け取った場合は、それに対応するシンボルを返す' do
          argv = 'list'
          option_hash = {
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

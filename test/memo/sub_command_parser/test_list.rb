# frozen_string_literal: true

class TestSubCommandParserList < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe '#execute' do
    def setup
      @scp = Memo::SubCommandParser::List.new
    end

    describe 'SubCommandParser::List' do
      it 'Memo::HelpMessageをインクルードしていること' do
        actual = Memo::SubCommandParser::List.include?(Memo::HelpMessage)

        _(actual).must_equal(true)
      end

      it 'Memo::SubCommandParserをインクルードしていること' do
        actual = Memo::SubCommandParser::List.include?(Memo::SubCommandParser)

        _(actual).must_equal(true)
      end

      describe '#execute' do
        it 'listのみの場合は、list: trueを返す' do
          argv = []

          actual = @scp.execute(argv: argv)

          _(actual).must_equal({ 'list' => true })
        end

        it '特定のオプションを受け取った場合は、それに対応するシンボルを返す' do
          str = 'list'
          option_hash = {
            '-d' => :duplicate,
            '--duplicate' => :duplicate
          }

          option_hash.each do |opt, expected_value|
            actual = @scp.execute(argv: [opt])
            _(actual).must_equal({ str => expected_value })
          end
        end

        it '引数を取る場合は、list:の値にその文字列を返す' do
          argv = %w[foo]

          actual = @scp.execute(argv: argv)

          _(actual).must_equal({ 'list' => 'foo' })
        end

        it '引数が32文字なら、list:の値にその文字列を返す' do
          arg = 'あ' * 32

          actual = @scp.execute(argv: [arg])

          _(actual).must_equal({ 'list' => arg })
        end

        it '引数が33文字なら、エラーメッセージを返す' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              @scp.execute(argv: ['あ' * 33])
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

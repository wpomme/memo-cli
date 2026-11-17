# frozen_string_literal: true

class TestSubCommandParserTag < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe 'SubCommandParser::Tag' do
    def setup
      @scp = Memo::SubCommandParser::Tag.new
      @cmd = 'tag'
    end

    describe '#execute' do
      it 'Memo::SubCommandParserをインクルードしていること' do
        actual = Memo::SubCommandParser::Tag.include?(Memo::SubCommandParser)

        _(actual).must_equal(true)
      end

      describe '#parse_one_argument: tag' do
        it '引数が存在しない場合は、エラーメッセージを表示する' do
          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              @scp.execute
            end

            _(exception.status).must_equal(2)
          end

          expected = NO_GIVEN_ARGS.gsub('CLI', @cmd)

          _(actual).must_equal(expected)
        end

        it '引数が一つ存在する場合は、文字列として解釈する' do
          argv = 'foo'

          actual = @scp.execute(argv: [argv])

          _(actual).must_equal({ @cmd => argv })
        end

        it '引数が二つ存在する場合は、エラーメッセージを表示する' do
          argv1 = 'foo'
          argv2 = 'bar'

          actual, = capture_io do
            exception = assert_raises(SystemExit) do
              @scp.execute(argv: [argv1, argv2])
            end

            _(exception.status).must_equal(2)
          end

          expected = TOO_MANY_ARGS.gsub('CLI', @cmd)

          _(actual).must_equal(expected)
        end
      end
    end
  end
end

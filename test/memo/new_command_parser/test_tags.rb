# frozen_string_literal: true

class TestNewCommandParser < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe '#execute' do
    def setup
      @scp = Memo::NewCommandParser::Tags.new
    end

    describe 'NewCommandParser::Tags' do
      it 'Memo::Messageをインクルードしていること' do
        actual = Memo::NewCommandParser::Tags.include?(Memo::HelpMessage)

        _(actual).must_equal(true)
      end

      it 'Memo::NewCommandParserをインクルードしていること' do
        actual = Memo::NewCommandParser::Tags.include?(Memo::NewCommandParser)

        _(actual).must_equal(true)
      end

      describe '#execute' do
        it 'tagsのみの場合は、tags: trueを返す' do
          argv = %w[tags]

          actual = @scp.execute(argv: argv)

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
            actual = @scp.execute(argv: args)
            _(actual).must_equal({ argv => option_hash[args.last] })
          end
        end

        it 'memo tags -hの場合' do
          skip 'TODO: ヘルプメッセージを表示する'
          argv = 'tags'
          options = ['-h', '--help']

          args = options.map { |opt| [argv, opt] }

          args.each do |arg|
            actual = @scp.execute(argv: arg)
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
              @scp.execute(argv: argv)
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
            @scp.execute(argv: args)
          end
        end
      end
    end
  end
end

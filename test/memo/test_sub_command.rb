# frozen_string_literal: true

class TestSubCommand < Minitest::Test
  include Memo::Message
  include Memo::HelpMessage

  describe '#execute' do
    def setup
      @scp = Memo::SubCommand.new
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
  end
end

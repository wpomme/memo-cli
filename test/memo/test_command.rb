# frozen_string_literal: true

class TestCommand < Minitest::Test
  describe 'Command' do
    it '#execute' do
      skip 'TODO: サブコマンドによって該当のクラスを呼び出していることを確認したい'
      actual = Memo::Command.new.execute(['dirs'])

      _(actual).must_equal(false)
    end
  end
end

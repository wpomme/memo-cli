# frozen_string_literal: true

module Memo
  module DB
    module Prepare
      class << self
        # /db/の中に該当のデータベースがあれば、そのデータベースに接続する
        # connectionhはdbをブロックで呼び出すと自動的に切断される
        # => connectionは極力ブロックで使用すること
        # そうでない場合は手動で切断する必要がある
        # TODO: DB切断の方法を考える
        # NOTE: 接続した結果は定数にしまうのがベスト
        # ref: https://sequel.jeremyevans.net/doc/opening_databases.html#label-Passing+a+block+to+either+method
        # => it’s best to store the result of Sequel.connect in a constant, as recommended above.
        def execute
          database_path = Memo::Config.target_db

          prepare(database_path)
        end

        def prepare(database_path)
          FileUtils.touch(database_path) unless FileTest.file?(database_path)
          Sequel.sqlite(database_path)
          # Sequel.connect("sqlite://#{database_path}")
        end
      end

      private_class_method :prepare
    end
  end
end

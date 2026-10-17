# frozen_string_literal: true

module Memo
  module Database
    module Prepare
      class << self
        # connectionhはdbをブロックで呼び出すと自動的に切断される
        # => connectionは極力ブロックで使用すること
        # そうでない場合は手動で切断する必要がある
        def execute
          database_path = Memo::Config.target_database

          prepare(database_path)
        end

        # TODO: DBへの接続が残っている場合があるため
        def disconnect
          Memo::Database::DB.disconnect
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

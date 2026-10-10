# frozen_string_literal: true

module Memo
  module DB
    module Connection
      class << self
        # /db/の中に該当のデータベースがあれば、そのデータベースに接続する
        def execute(path = 'production_memo.db')
          database_path = File.join(Dir.pwd, '/db', path)

          prepare(database_path)
        end

        def prepare(database_path)
          FileUtils.touch(database_path) unless FileTest.file?(database_path)
          Sequel.sqlite(database_path)
        end
      end

      private_class_method :prepare
    end
  end
end

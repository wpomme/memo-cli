# frozen_string_literal: true

module Memo
  module Database
    module Connection
      class << self
        def execute(database_path: Memo::Config.target_database)
          FileUtils.touch(database_path) unless FileTest.file?(database_path)
          db = Sequel.sqlite(database_path)

          if block_given?
            yield db
            db.disconnect
          else
            db
          end
        end
      end
    end
  end
end

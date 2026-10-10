# frozen_string_literal: true

module Memo
  module DB
    module Models
      def self.directory(db)
        Sequel::Model.db = db

        klass = Class.new(Sequel::Model)

        Models.const_set('Directory', klass)
      end
    end
  end
end

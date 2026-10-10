# frozen_string_literal: true

module Memo
  module DB
    module Models
      def self.file(db)
        Sequel::Model.db = db

        klass = Class.new(Sequel::Model)

        klass.one_to_one :directory
        klass.many_to_many :tags

        Models.const_set('File', klass)
      end
    end
  end
end

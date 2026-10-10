# frozen_string_literal: true

module Memo
  module DB
    module Models
      def self.tag(db)
        Sequel::Model.db = db

        klass = Class.new(Sequel::Model)

        klass.many_to_many :files

        Models.const_set('Tag', klass)
      end
    end
  end
end

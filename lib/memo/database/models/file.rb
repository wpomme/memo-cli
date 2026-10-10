# frozen_string_literal: true

module Memo
  module Database
    module Models
      class File < Sequel::Model
        plugin :validation_helpers

        one_to_one :directory
        many_to_many :tags
      end

      # def self.file(db)
      #   Sequel::Model.db = db
      #
      #   klass = Class.new(Sequel::Model)
      #
      #   klass.one_to_one :directory
      #   klass.many_to_many :tags
      #
      #   Models.const_set('File', klass)
      # end
    end
  end
end

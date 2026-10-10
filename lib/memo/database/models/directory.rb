# frozen_string_literal: true

module Memo
  module Database
    module Models
      class Directory < Sequel::Model
        plugin :validation_helpers

        def validate
          super
          validates_unique :absolute_path
        end
      end
      # def self.directory
      #   Memo::Database::DB.synchronize do |db|
      #     # NOTE: https://sequel.jeremyevans.net//rdoc/classes/Sequel/Model/ClassMethods.html#method-i-db-3D
      #     # TODO: db= は使わない方がいいみたい
      #     # => ref: https://github.com/jeremyevans/sequel#sequel-models
      #     Sequel::Model.db = db
      #
      #     klass = Class.new(Sequel::Model(:directories))
      #
      #     klass.class_eval do
      #       plugin :validation_helpers
      #
      #       def validate
      #         super
      #         validates_unique :absolute_path
      #       end
      #     end
      #
      #     Models.const_set('Directory', klass) unless Models.const_defined?('Directory', klass)
      #     klass
      #   end
      # end
    end
  end
end

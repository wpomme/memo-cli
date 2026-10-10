# frozen_string_literal: true

module Memo
  module DB
    module Models
      def self.directory
        Memo::DB::CONNECTION.synchronize do |db|
          # NOTE: https://sequel.jeremyevans.net//rdoc/classes/Sequel/Model/ClassMethods.html#method-i-db-3D
          # TODO: db= は使わない方がいいみたい
          Sequel::Model.db = db

          klass = Class.new(Sequel::Model(:directories))

          klass.class_eval do
            plugin :validation_helpers

            def validate
              super
              validates_unique :absolute_path
            end
          end

          Models.const_set('Directory', klass) unless Models.const_defined?('Directory', klass)
          klass
        end
      end
    end
  end
end

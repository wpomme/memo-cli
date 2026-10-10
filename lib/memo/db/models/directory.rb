# frozen_string_literal: true

module Memo
  module DB
    module Models
      def self.directory(db)
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

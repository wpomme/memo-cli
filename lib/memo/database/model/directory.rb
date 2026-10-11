# frozen_string_literal: true

module Memo
  module Database
    module Model
      class Directory < Sequel::Model
        plugin :validation_helpers

        def validate
          super
          validates_unique :absolute_path
        end
      end
    end
  end
end

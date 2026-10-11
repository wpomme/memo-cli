# frozen_string_literal: true

module Memo
  module Database
    module Model
      class Tag < Sequel::Model
        plugin :validation_helpers

        many_to_many :files
      end
    end
  end
end

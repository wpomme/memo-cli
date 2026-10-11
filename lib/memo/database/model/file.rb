# frozen_string_literal: true

module Memo
  module Database
    module Model
      class File < Sequel::Model
        plugin :validation_helpers

        one_to_one :directory
        many_to_many :tags
      end
    end
  end
end

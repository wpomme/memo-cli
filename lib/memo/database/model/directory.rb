# frozen_string_literal: true

module Memo
  module Database
    module Model
      class Directory < Sequel::Model
        plugin :validation_helpers
      end
    end
  end
end

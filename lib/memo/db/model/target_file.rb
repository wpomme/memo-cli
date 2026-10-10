# frozen_string_literal: true

module Memo
  module Model
    DB.prepare

    class TargetFile < Sequel::Model
      one_to_one :directory
      many_to_many :tags
    end
  end
end

# frozen_string_literal: true

module Memo
  module Model
    DB.prepare

    class Tag < Sequel::Model
      many_to_many :target_file
    end
  end
end

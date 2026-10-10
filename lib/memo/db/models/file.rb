# frozen_string_literal: true

module Memo
  module DB
    module Models
      class File
        def initialize(db)
          Sequel::Model.db = db

          Class.new(Sequel::Model) do
            def initialize
              super
              one_to_one :directory
              many_to_many :tags
            end
          end
        end
      end
    end
  end
end

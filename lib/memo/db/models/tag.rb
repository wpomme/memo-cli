# frozen_string_literal: true

module Memo
  module DB
    module Models
      class Tag
        def initialize(db)
          Sequel::Model.db = db

          Class.new(Sequel::Model) do
            def initialize
              super
              many_to_many :files
            end
          end
        end
      end
    end
  end
end

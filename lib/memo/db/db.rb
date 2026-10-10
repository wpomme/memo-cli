# frozen_string_literal: true

module Memo
  module DB
    CONNECTION = Memo::DB::Prepare.execute
  end
end

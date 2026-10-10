# frozen_string_literal: true

module Memo
  module Controller
    class Directory
      def create
        absolute_paths = Memo::DB::Repository.new.absolute_paths

        absolute_paths.each do |absolute_path|
          Memo::DB::Model::Directory.new(absolute_path: absolute_path)
        end
      end
    end
  end
end

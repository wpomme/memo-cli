# frozen_string_literal: true

module Memo
  module Database
    module Service
      module_function

      def absolute_paths(target_dirs = Memo::Config.target_dirs)
        target_dirs.flat_map do |root_dir|
          [root_dir].concat(
            Dir.glob('**/*/', base: root_dir).map do |rel_path|
              File.join(root_dir, rel_path)
            end
          )
        end
      end
    end
  end
end

# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class FileTag
        extend Forwardable

        attr_reader :dataset

        def_delegators :@dataset, :count, :delete

        def initialize
          @dataset = Memo::Database.db[:files_tags]
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<Integer, String>] Tagテーブルの主キーのIDがキーで、そのタグ名が値となるハッシュを返す
        def seeds
          insert_all
        end

        private

        # 次の二つのハッシュから、ファイルIDがキーで、タグ名の配列が値となるハッシュを返す
        # 1. {file_id: file_path}
        # 2. {file_path: tag_names}
        #    => {file_id: tag_names}
        #
        # @return [Hash<Integer, Array<String>>]
        def to_file_id_tag_names
          file_dataset = Memo::Database::Controller::File.new
          id_to_absolute_filename = file_dataset.id_to_absolute_filename

          absolute_filename_to_tags = Memo::Loader::FileLoader.new.absolute_filename_to_tags

          id_to_absolute_filename.each_with_object({}) do |(file_id, file_path), result|
            result[file_id] = absolute_filename_to_tags[file_path]
          end
        end

        # file_idに紐付いているタグ名をタグIDに変換する
        #
        # 返還前: {file_id: tag_names}
        # 変換後: {file_id: tag_ids}
        #
        # @return [Hash<Integer, Array<Integer>>]
        def from_tags_to_tag_ids(file_id_to_tag_names)
          tag_dataset = Memo::Database::Controller::Tag.new
          tag_to_id = tag_dataset.tag_to_id

          file_id_to_tag_names.transform_values do |tags|
            tags.map do |tag|
              tag_to_id[tag]
            end
          end
        end

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<Integer, String>] Tagテーブルの主キーのIDがキーで、そのタグ名が値となるハッシュを返す
        def insert_all
          file_tag_id_hash = from_tags_to_tag_ids(to_file_id_tag_names)

          file_tag_id_hash.each do |files_id, tags_ids|
            tags_ids.each do |tags_id|
              @dataset.insert(
                files_id: files_id,
                tags_id: tags_id
              )
            end
          end
        end
      end
    end
  end
end

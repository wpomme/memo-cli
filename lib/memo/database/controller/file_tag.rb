# frozen_string_literal: true

module Memo
  module Database
    module Controller
      class FileTag
        def initialize
          @dataset = DB[:files_tags]
        end

        # ディレクトリテーブルに必要なデータを挿入する
        #
        # @return [Hash<Integer, String>] Tagテーブルの主キーのIDがキーで、そのタグ名が値となるハッシュを返す
        def seeds(file_seeds_result, tag_seeds_result)
          file_id_to_tag_names = to_file_id_tag_names(file_seeds_result)
          file_tag_id_hash = from_tags_to_tag_ids(file_id_to_tag_names, tag_seeds_result)

          insert_all(file_tag_id_hash)
        end

        private

        # 次の二つのハッシュから、ファイルIDがキーで、タグ名の配列が値となるハッシュを返す
        # File.seeds => {file_id: file_path}
        # FileLoader.file_path_tags_hash => {file_path: tag_names}
        # will return => {file_id: tag_names}
        #
        # @param file_seeds_result [Hash<Integer, String>]
        #
        # @return [Hash<Integer, Array<String>>]
        def to_file_id_tag_names(file_seeds_result)
          file_loader = Memo::Database::FileLoader.new
          file_path_tags_hash = file_loader.file_path_tags_hash

          file_seeds_result.each_with_object({}) do |(file_id, file_path), result|
            result[file_id] = file_path_tags_hash[file_path]
          end
        end

        # 二つのハッシュを受け取って、次のようなハッシュに変換して値を返す
        # {file_id: tag_names} => {file_id: tag_ids}
        #
        # @return [Hash<Integer, Array<Integer>>]
        def from_tags_to_tag_ids(file_id_to_tag_names, tag_seeds_result)
          file_id_to_tag_names.transform_values do |tags|
            tags.map do |tag|
              tag_seeds_result[tag]
            end
          end
        end

        # 対象のデータをテーブルに一括して挿入する
        #
        # @return [Hash<Integer, String>] Tagテーブルの主キーのIDがキーで、そのタグ名が値となるハッシュを返す
        def insert_all(file_tag_id_hash)
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

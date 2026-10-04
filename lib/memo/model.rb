# frozen_string_literal: true

module Memo
  module Model
    #  対象ディレクトリのファイル情報を保存するための値オブジェクト
    #
    # @!attribute [w] full_path
    #   @return [String] memoディレクトリの中にあるファイルの絶対パス。メモを読み取るために使う
    # @!attribute [w] rel_path
    #   @return [String] 対象のディレクトリからそのファイルへのパス
    # @!attribute [w] target_dir
    #   @return [String] このSeedがどのtarget_dirから読み込まれているかを示す値
    # @!attribute [w] parent_dir
    #   @return [String] そのファイルが格納されているディレクトリ
    # @!attribute [w] basename
    #   @return [String] 対象のファイルのファイル名
    # @!attribute [w] type
    #   @return [:file | :directory] 対象のファイルがディレクトリかどうか
    # @!attribute [w] tags
    #   @return [Array<String>] 対象のファイルのフロントマター部分のtagsの値
    Seed = Struct.new(:full_path, :rel_path, :target_dir, :parent_dir, :basename, :type, :tags)

    # サブコマンドの詳細を作成するための構造体
    #
    # @!attribute [r] :sub_command_form
    #   @return [String] memoの後にこの値を指定するとサブコマンドとして機能する文字列
    # @!attribute [r] :long_form
    #   @return [String] サブコマンドのロングフォーム。OptionParser#onに準ずる
    # @!attribute [r] :short_form
    #   @return [String] サブコマンドのショートフォーム。OptionParser#onに準ずる
    # @!attribute [r] :desc
    #   @return [String] サブコマンドの詳細。OptionParser#onに準ずる
    # @!attribute [r] :option_argv
    #   @return [String | Void] サブコマンドが引数を取る場合に、OptionParser#onのロングフォームに指定する値を定めたもの
    # @!attribute [r] :parsed_block
    #   @return [String | Void] OptionsParser#parse!で実行する手続き
    SubCommandSpec = Struct.new(:sub_command_form, :long_form, :short_form, :desc, :option_argv, :parsed_block) do
      def initialize(...)
        super
        freeze
      end

      # サブコマンドのそれぞれの形式を配列で返す。テストコード用
      # @return [Array<String>]
      def take_command_forms
        deconstruct_keys(%i[sub_command_form long_form short_form]).values
      end

      def long_form_with_argv
        "#{long_form} #{option_argv}"
      end

      def optional?
        /\A\[\w+\]\Z/.match?(option_argv)
      end

      def required?
        /\A\w+\Z/.match?(option_argv)
      end

      # サブコマンドを受け取ったら、そのショートフォームを返す
      # @params word [<String>]
      # @return [<String>]
      def to_opts(word)
        short_form if deconstruct_keys(%i[sub_command_form long_form short_form]).values.include?(word)
      end
    end

    SubCommandSubSpec = Struct.new(:sub_command_form, :long_form, :short_form) do
      def initialize(...)
        super
        freeze
      end

      # サブコマンドのそれぞれの形式を配列で返す。テストコード用
      # @return [Array<String>]
      def take_command_forms
        deconstruct_keys(%i[sub_command_form long_form short_form]).values
      end

      # サブコマンドを受け取ったら、そのサブコマンドのシンボルを返す
      def to_sym(word)
        sub_command_form.intern if deconstruct_keys(%i[sub_command_form long_form short_form]).values.include?(word)
      end
    end

    # 対象のディレクトリを文字列で検索してヒットしたときに返す値
    SearchLine = Struct.new(:path, :line_number, :line) do
      def initialize(...)
        super
        freeze
      end

      def to_view(word)
        "#{path}:#{line_number}:#{line.sub(word, Rainbow(word).red)}"
      end
    end
  end
end

# frozen_string_literal: true

# require_relative '../helper'

class TestConfig < Minitest::Test
  describe 'Config' do
    describe '#load' do
      it '設定ファイルが見つからない場合は、例外を送出して終了する' do
        _ do
          does_not_exist_config_path = File.expand_path('../../config/does_not_exist_config.yml', __dir__)

          load_method = Memo::Config.method(:load)
          load_method.call(does_not_exist_config_path)
        end.must_raise(Errno::ENOENT)
      end
    end

    describe '#target_dirs - モックデータによるテスト' do
      def setup
        test_tmp_dir = '/var/tmp-for-config-yml'
        test_tmp_target_dirnames = ['/config-1/', '/config-2/', '/config-3/']

        @config_yml_test_dir = File.join(Dir.home, test_tmp_dir)
        FileUtils.mkdir_p(@config_yml_test_dir)

        @config_yml_test_target_dirs = test_tmp_target_dirnames.map do |dir|
          File.join(@config_yml_test_dir, dir)
        end

        # 絶対パスからホームディレクトリを引いた文字列を設定ファイルに記載する
        @config_yml_test_target_dirs.map do |dir|
          "  - #{dir.sub(Dir.home, '')}"
        end
      end

      def teardown
        # Config.loadを呼び出して、対象のディレクトリを元に戻す
        load_method = Memo::Config.method(:load)
        load_method.call

        FileUtils.remove_entry_secure(@config_yml_test_dir)
      end

      it 'モックの設定ファイルから読み込まれたディレクトリが存在すれば、そのディレクトリの値を返すこと' do
        test_config_yml = 'test_config.yml'

        test_config_yml_content_arr = ['target_dirs:'].concat(
            @config_yml_test_target_dirs.map { |dir| "  - #{dir.sub(Dir.home, '')}" }
          )

        test_config_yml_path = File.join(@config_yml_test_dir, test_config_yml)

        # 設定ファイルと対象のディレクトリを作成する
        File.write(test_config_yml_path, test_config_yml_content_arr.join("\n"))
        @config_yml_test_target_dirs.each do |dir|
          FileUtils.mkdir_p(dir)
        end

        load_method = Memo::Config.method(:load)
        load_method.call(test_config_yml_path)

        actual = Memo::Config.target_dirs

        expected = @config_yml_test_target_dirs

        _(actual).must_equal(expected)
      end

      it 'モックの設定ファイルから読み込まれたディレクトリが存在しなければ、target_dirsを呼び出した時点で、例外を送出すること' do
        test_config_yml = 'test_config.yml'

        test_config_yml_content = <<~CONTENT
          target_dirs:
            - /var/tmp-for-config-yml/does_not_exist_config-1
            - /var/tmp-for-config-yml/does_not_exist_config-2
        CONTENT

        test_config_yml_path = File.join(@config_yml_test_dir, test_config_yml)

        # 設定ファイルと対象のディレクトリを作成する
        File.write(test_config_yml_path, test_config_yml_content)
        @config_yml_test_target_dirs.each do |dir|
          FileUtils.mkdir_p(dir)
        end
        _ do
          load_method = Memo::Config.method(:load)
          load_method.call(test_config_yml_path)

          Memo::Config.target_dirs
        end.must_raise(StandardError)
      end
    end

    describe '#target_dirs' do
      it '#target_dirsが文字列型の一次元配列であること' do
        test_target_dir = Memo::Config.target_dirs

        actual = test_target_dir.all?(String)

        _(actual).must_equal(true)
      end

      it '#target_dirsの全ての値がディレクトリであること' do
        test_target_dir = Memo::Config.target_dirs

        actual = test_target_dir.all? do |dir|
          FileTest.directory?(dir)
        end

        _(actual).must_equal(true)
      end
    end
  end
end

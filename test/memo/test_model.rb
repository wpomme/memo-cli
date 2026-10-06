# frozen_string_literal: true

require_relative '../helper'

class TestModel < Minitest::Test
  include Memo::Model

  describe 'SubCommandSpec' do
    describe '#initialize' do
      it 'オブジェクトを生成できる' do
        actual = SubCommandSpec.new('test', '--test', '-t', 'memo CLIのテスト ', nil, nil)

        _(actual).must_be_instance_of(SubCommandSpec)
      end
    end

    describe '#long_form_with_argv' do
      it 'OptionParser#onに登録する引数つきのロングオプションとなる文字列を返す' do
        target_long_form = '--test'
        target_argv = '[DIRS]'

        test_sub_command_spec = SubCommandSpec.new('test', target_long_form, '-t', 'memo CLIのテスト ', target_argv, nil)

        actual = test_sub_command_spec.long_form_with_argv

        expected = "#{target_long_form} #{target_argv}"

        _(actual).must_equal(expected)
      end
    end

    describe 'Model::Seed' do
      include MemoTestLifecycleHooks

      describe 'direcotory?' do
        it 'dir_seedsは全てディレクトリである' do
          test_dir_seeds = @test_repo.instance_variable_get(:@dir_seeds)

          actual = test_dir_seeds.all?(&:directory?)

          _(actual).must_equal(true)
        end
      end

      describe 'file?' do
        it 'file_seedsは全てファイルである' do
          actual = @test_seeds.all?(&:file?)

          _(actual).must_equal(true)
        end
      end
    end
  end
end

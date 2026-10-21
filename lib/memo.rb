# frozen_string_literal: true

require 'yaml'
require 'rainbow'
require 'optparse'
require 'sequel'
require 'forwardable'

require_relative 'memo/config'
require_relative 'memo/version'
require_relative 'memo/message'
require_relative 'memo/help_message'
require_relative 'memo/loader/file_loader'
require_relative 'memo/loader/directory_loader'
require_relative 'memo/database/prepare'
require_relative 'memo/database/setup'
# require_relative 'memo/database/model/directory'
# require_relative 'memo/database/model/tag'
# require_relative 'memo/database/model/file'
require_relative 'memo/database/controller/config_directory'
require_relative 'memo/database/controller/directory'
require_relative 'memo/database/controller/file'
require_relative 'memo/database/controller/tag'
require_relative 'memo/database/controller/file_tag'
require_relative 'memo/command_view'
require_relative 'memo/view/read'
require_relative 'memo/view/search'
require_relative 'memo/view/tag'
require_relative 'memo/view/tags'
require_relative 'memo/view/dirs'
require_relative 'memo/view/list'
require_relative 'memo/model'
require_relative 'memo/sub_command_parser'
require_relative 'memo/service'
require_relative 'memo/command'

module Memo
  class Error < StandardError; end
end

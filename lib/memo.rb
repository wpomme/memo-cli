# frozen_string_literal: true

require 'yaml'
require 'rainbow'
require 'optparse'
require 'sequel'

require_relative 'memo/config'
require_relative 'memo/version'
require_relative 'memo/message'
require_relative 'memo/database/service'
require_relative 'memo/database/file_loader'
require_relative 'memo/database/prepare'
require_relative 'memo/database/db'
require_relative 'memo/database/setup'
require_relative 'memo/database/model/directory'
require_relative 'memo/database/model/tag'
require_relative 'memo/database/model/file'
require_relative 'memo/database/controller/directory'
require_relative 'memo/database/controller/file'
require_relative 'memo/model'
require_relative 'memo/sub_command_parser'
require_relative 'memo/service'
require_relative 'memo/repository'
require_relative 'memo/mapper'
require_relative 'memo/view'
require_relative 'memo/command'

module Memo
  class Error < StandardError; end
end

# frozen_string_literal: true

require_relative "memo/config"
require_relative "memo/version"
require_relative "memo/message"
require_relative "memo/sub_command_parser"
require_relative "memo/model"
require_relative "memo/service"
require_relative "memo/repository"
require_relative "memo/mapper"
require_relative "memo/view"
require_relative "memo/command"

module Memo
  class Error < StandardError; end
end

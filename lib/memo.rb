# frozen_string_literal: true

require_relative "memo/options/parser"
require_relative "memo/command"
require_relative "memo/docs"
require_relative "memo/Repository"

module Memo
  class Error < StandardError; end
  VERSION = "0.1.0"
end

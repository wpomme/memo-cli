# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in memo.gemspec
gemspec

group :production do
  gem "rainbow", "~>3.1.1"
  gem "sequel", "~>5.107"
  gem 'sqlite3', '~> 2.9.5'
end

group :development do
  gem "irb", "~> 1.18.0"
  gem "rake", "~> 13.0"
  gem "rbs", "~> 4.1.1"

  gem "minitest", "~> 6.0.6"
  gem "minitest-mock", "~> 5.27"
  gem "rubocop", "~> 1.21"

  gem "neovim", "~> 0.10.0"
  gem "yard", "~> 0.9.45"
end

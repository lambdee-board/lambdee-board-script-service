# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'awesome_print' # better output in the console
gem 'iodine', '~> 0.7' # HTTP and WebSocket server
gem 'refrigerator' # for freezing built-in classes/modules
gem 'shale' # object mapper and serializer for JSON and other formats
gem 'sinatra' # HTTP server framework
gem 'sorted_set' # adds a Set subclass which sorts its contents

group :development do
  gem 'solargraph' # language server for IDEs
  gem 'yard' # automatic code documentation from comments
end

group :development, :test do
  gem 'brakeman' # vulnerabilities checker
  gem 'bundler-audit' # dependency analyser
  gem 'debug' # debugger
  gem 'rake' # automation tasks
  gem 'rubocop' # linter
end

group :test do
  gem 'minitest' # test framework
  gem 'rack-test' # utilities for testing Rack (primitive HTTP server library)
end

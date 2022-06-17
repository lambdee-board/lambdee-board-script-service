# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby ::File.read('.ruby-version').chomp.strip

gem 'awesome_print'
gem 'iodine', '~> 0.7'
gem 'msgpack'
gem 'refrigerator'
gem 'sinatra'
gem 'sorted_set'

group :development do
  gem 'solargraph'
  gem 'yard'
end

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'debug'
  gem 'rake'
  gem 'rubocop'
end

group :test do
  gem 'minitest'
  gem 'rack-test'
end

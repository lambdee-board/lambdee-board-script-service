# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

gem 'awesome_print'
gem 'iodine', '~> 0.7'
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

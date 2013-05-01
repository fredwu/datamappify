require 'coveralls'
require 'simplecov'
require 'pry'
require 'rspec/autorun'
require 'database_cleaner'

case ENV['COV'].to_i
when 1 then SimpleCov.start
when 2 then Coveralls.wear!
end

SimpleCov.configure do
  add_filter "/spec/"
end

require File.expand_path('../../lib/datamappify', __FILE__)

%w{tables entities repositories shared}.each do |sub_dir|
  Dir[File.expand_path("../support/#{sub_dir}/**/*.rb", __FILE__)].each { |f| require f }
end

DATA_PROVIDERS = ENV['DATA_PROVIDER'] ? [ENV['DATA_PROVIDER']] : %w{ActiveRecord Sequel}

RSpec.configure do |config|
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end
end

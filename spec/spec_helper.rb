require 'simplecov'
require 'pry'
require 'rspec/autorun'
require 'database_cleaner'

SimpleCov.start

SimpleCov.configure do
  add_filter "/spec/"
end

require File.expand_path('../../lib/datamappify', __FILE__)

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  DatabaseCleaner.strategy = :truncation

  config.before do
    DatabaseCleaner.clean
  end
end

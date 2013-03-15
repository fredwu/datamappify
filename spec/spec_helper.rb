require 'simplecov'
require 'pry'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/colorize'
require 'database_cleaner'

SimpleCov.start

SimpleCov.configure do
  add_filter "/spec/"
end

require File.expand_path('../../lib/datamappify', __FILE__)

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

DatabaseCleaner.strategy = :truncation

class MiniTest::Spec
  before do
    DatabaseCleaner.clean
  end
end

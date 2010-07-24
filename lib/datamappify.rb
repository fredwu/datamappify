raise "Please install the AutoMigrations plugin from http://github.com/pjhyett/auto_migrations" unless defined?(AutoMigrations.run)

require 'datamappify/associations'
require 'datamappify/collection'
require 'datamappify/fake/column'
require 'datamappify/fake/connection'
require 'datamappify/fake/index'
require 'datamappify/resource'
require 'datamappify/schema_dumper'

module Datamappify
  def self.run
    Datamappify::SchemaDumper.dump_to_file
    AutoMigrations.run
  end
end
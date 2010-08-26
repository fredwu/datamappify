raise "ActiveRecord is not present!" unless defined?(ActiveRecord)

require 'auto_migrations'
require 'datamappify/associations'
require 'datamappify/collection'
require 'datamappify/fake/column'
require 'datamappify/fake/connection'
require 'datamappify/fake/index'
require 'datamappify/railtie'
require 'datamappify/resource'
require 'datamappify/schema_dumper'

module Datamappify
  def self.run
    Datamappify::SchemaDumper.dump_to_file
    AutoMigrations.run
  end
end
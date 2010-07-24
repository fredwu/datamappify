module Datamappify
  class SchemaDumper < ActiveRecord::SchemaDumper
    def self.dump_to_file
      File.open(ENV['SCHEMA'] || "#{Rails.root}/db/schema.rb", "w") do |file|
        Datamappify::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
    
    def initialize(connection)
      super(connection)
      @connection = Datamappify::Fake::Connection.new
    end
    
    def tables(stream)
      Datamappify::Collection.get.each do |entry|
        tbl = entry[:table_name] or entry[:resource].pluralize
        table(tbl, stream)
      end
    end
  end
end
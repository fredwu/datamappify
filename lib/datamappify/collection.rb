module Datamappify
  class Collection
    def self.get
      collection = []
      
      Dir.glob(Rails.root.join('app', 'models', '**', '*.rb')).each do |file|
        name  = file[/.*\/(.*)\.rb/, 1]
        klass = name.camelize.constantize
        
        next unless klass.included_modules.include?(Datamappify::Resource) and klass.respond_to?(:properties)
        
        collection << {
          :name       => name,
          :table_name => klass.table_name,
          :properties => klass.properties,
          :indexes    => klass.indexes,
        }
      end
      
      Associations.join_tables.each do |table_name, ids|
        collection << {
          :name       => table_name,
          :table_name => table_name,
          :properties => [{
            :name     => ids[0],
            :sql_type => :integer,
            :options  => {},
          }, {
            :name     => ids[1],
            :sql_type => :integer,
            :options  => {},
          }],
          :indexes    => [{
            :columns => ids[0],
            :options => {},
          }, {
            :columns => ids[1],
            :options => {},
          }],
        }
      end
      
      collection
    end
  end
end
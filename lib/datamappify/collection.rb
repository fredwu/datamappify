module Datamappify
  class Collection
    def self.get
      collection = []
      
      Dir.glob(Rails.root.join('app', 'models', '**', '*.rb')).each do |file|
        name  = file[/.*\/(.*)\.rb/, 1]
        klass = name.camelize.constantize
        
        next unless klass.respond_to?(:properties)
        
        options = klass.respond_to?(:resource_options) ? klass.resource_options : []
        
        collection << {
          :resource   => name,
          :table_name => klass.table_name,
          :properties => klass.properties,
          :indexes    => klass.indexes,
          :options    => options,
        }
      end
      
      collection
    end
  end
end
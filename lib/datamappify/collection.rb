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
      
      collection
    end
  end
end
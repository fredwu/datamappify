module Datamappify
  module Resource
    def self.included(model)
      model.send :cattr_accessor, :properties
      model.send :cattr_accessor, :indexes
      
      model.extend Resource::ClassMethods
      model.extend Associations::ClassMethods
    end
    
    module ClassMethods
      def self.extended(model)
        @@model = model
        
        @@model.properties = []
        @@model.indexes    = []
      end
      
      def property(name, sql_type=nil, options={})
        @@model.properties << {
          :name     => name,
          :sql_type => sql_type,
          :options  => options,
        }
      end
      
      def add_index(columns, options={})
        @@model.indexes << {
          :columns => columns,
          :options => options,
        }
      end
    end
  end
end
module Datamappify
  module Resource
    def self.included(model)
      model.extend ClassMethods
      model.extend Datamappify::Associations::ClassMethods
      model.send :properties=, []
      model.send :indexes=, []
    end
  end
  
  module ClassMethods
    mattr_accessor :properties
    mattr_accessor :indexes
    
    @@properties = []
    @@indexes    = []
    
    def property(name, sql_type=nil, *options)
      @@properties << {
        :name     => name,
        :sql_type => sql_type,
        :options  => options,
      }
    end
    
    def add_index(property_name, label=nil, unique=false, lengths=nil)
      @@indexes << {
        :property_name => property_name,
        :label         => label,
        :unique        => unique,
        :lengths       => lengths,
      }
    end
  end
end
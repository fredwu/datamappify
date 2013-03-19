require 'datamappify/data/provider/sequel/persistence'

module Datamappify
  module Data
    module Sequel
    end

    module Provider
      module Sequel
        def self.build_data_class(data_class_name)
          Datamappify::Data::Sequel.const_set(
            data_class_name, Class.new(::Sequel::Model(data_class_name.pluralize.underscore.to_sym))
          )
        end
      end
    end
  end
end

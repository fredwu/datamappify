require 'datamappify/data/provider/active_record/persistence'

module Datamappify
  module Data
    module ActiveRecord
    end

    module Provider
      module ActiveRecord
        def self.build_data_class(data_class_name)
          Datamappify::Data::ActiveRecord.const_set(data_class_name, Class.new(::ActiveRecord::Base))
        end
      end
    end
  end
end

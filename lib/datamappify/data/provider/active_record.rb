require 'datamappify/data/provider/active_record/base'
require 'datamappify/data/provider/active_record/persistence'

module Datamappify
  module Data
    module ActiveRecord
      def self.build_data_class(data_class_name)
        self.const_set(data_class_name, Class.new(Data::ActiveRecord::Base))
      end
    end
  end
end

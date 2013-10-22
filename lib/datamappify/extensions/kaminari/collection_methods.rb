module Datamappify
  module Extensions
    module Kaminari
      module CollectionMethods
        def self.included(klass)
          klass.class_eval do
            include ::Kaminari::ConfigurationMethods::ClassMethods
            include ::Kaminari::PageScopeMethods

            attr_accessor :limit_value, :offset_value, :total_count
          end
        end
      end
    end
  end
end

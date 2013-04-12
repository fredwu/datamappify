module Datamappify
  module Data
    # A convenient class for finding or building a data record
    module Record
      # @param provider_name [String]
      # @param source_class_name [String]
      def self.find_or_build(provider_name, source_class_name)
        Provider.const_get(provider_name).find_or_build_record_class(source_class_name)
      end
    end
  end
end

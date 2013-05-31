module Datamappify
  module Data
    # A convenient class for finding or building a data record
    module Record
      class << self
        # @param provider_name [String]
        #
        # @param source_class_name [String]
        def find_or_build(provider_name, source_class_name)
          Provider.const_get(provider_name).find_or_build_record_class(source_class_name)
        end

        def build_association(attribute, default_source_class)
          Provider.const_get(attribute.provider_name).build_record_association(attribute, default_source_class)
        end
      end
    end
  end
end

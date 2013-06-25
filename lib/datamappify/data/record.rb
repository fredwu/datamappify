module Datamappify
  module Data
    # A convenient class for finding or building a data record
    module Record
      class << self
        # @param provider_name [String]
        #
        # @param source_class_name (see CommonProvider::ModuleMethods#find_or_build_record_class)
        #
        # @return [Object]
        def find_or_build(provider_name, source_class_name)
          Provider.const_get(provider_name).find_or_build_record_class(source_class_name)
        end

        # @param attribute [Attribute]
        #
        # @param default_source_class [Class]
        #
        # @return [void]
        def build_association(attribute, default_source_class)
          Provider.const_get(attribute.provider_name).build_record_association(attribute, default_source_class)
        end

        def build_reversed_association(attribute, default_source_class)
          Provider.const_get(attribute.provider_name).build_record_reversed_association(attribute, default_source_class)
        end
      end
    end
  end
end

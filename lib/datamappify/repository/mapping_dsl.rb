module Datamappify
  module Repository
    module MappingDSL
      # @param entity_class [Class] entity class
      # @return [void]
      def for_entity(entity_class)
        data_mapper.entity_class = entity_class
      end

      # @param provider_name [String] name of data provider
      # @return [void]
      def default_provider(provider_name)
        data_mapper.default_provider_name = provider_name.to_s
      end

      # @param (see Data::Mapper::Attribute#initialize)
      # @return [void]
      def map_attribute(name, source)
        data_mapper.custom_mapping[name] = source
      end
    end
  end
end

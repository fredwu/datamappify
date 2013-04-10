module Datamappify
  module Repository
    module MappingDSL
      def for_entity(entity_class)
        data_mapper.entity_class = entity_class
      end

      def default_provider(provider_name)
        data_mapper.default_provider_name = provider_name.to_s
      end

      def map_attribute(attribute, source)
        data_mapper.custom_mapping[attribute] = source
      end
    end
  end
end

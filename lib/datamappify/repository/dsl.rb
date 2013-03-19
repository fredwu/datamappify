module Datamappify
  module Repository
    module DSL
      def for_entity(entity_class)
        self.entity_class = entity_class
      end

      def default_provider(provider_name)
        self.class_eval { require "datamappify/data/provider/#{provider_name.to_s.underscore}" }

        provider_namespace = "Datamappify::Data::#{provider_name}"

        self.default_provider_class_name = provider_name.to_s
        self.default_data_class_name     = self.entity_class.name
      end

      def map_attribute(attribute, source)
        self.custom_attributes_mapping[attribute] = source
      end
    end
  end
end

module Datamappify
  module Repository
    module DSL
      def for_entity(entity_class)
        self.entity_class = entity_class
      end

      def map_attribute(attribute, source)
        self.custom_attributes_mapping[attribute] = source
      end
    end
  end
end

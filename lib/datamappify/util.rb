module Datamappify
  class Util
    class << self
      def attributes_filtered_by(entity, attribute_names)
        entity.attributes.select { |attr| attribute_names.include?(attr) }
      end

      def extract_entity_id(id_or_entity)
        id_or_entity.is_a?(Integer) ? id_or_entity : id_or_entity.id
      end
    end
  end
end

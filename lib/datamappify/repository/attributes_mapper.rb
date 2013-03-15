require 'datamappify/repository/attribute_source_data_class_builder'

module Datamappify
  module Repository
    class AttributesMapper
      def initialize(repository)
        @repository = repository

        map_entity_attributes
      end

      def build_data_classes
        @repository.data_mapping.each do |data_class_name, data_fields_mapping|
          AttributeSourceDataClassBuilder.build(data_class_name, data_fields_mapping)
        end
      end

      private

      def map_entity_attributes
        map_non_custom_entity_attributes
        map_custom_entity_attributes
      end

      def map_non_custom_entity_attributes
        @repository.data_mapping[@repository.entity_class.name] = {}

        non_custom_attributes.each do |attribute_name|
          @repository.data_mapping[@repository.entity_class.name][attribute_name] = attribute_name
        end
      end

      def non_custom_attributes
        @repository.entity_class.attribute_set.entries.map(&:name) - @repository.custom_attributes_mapping.keys
      end

      def map_custom_entity_attributes
        @repository.custom_attributes_mapping.each do |attribute_name, source|
          map_custom_entity_attribute(attribute_name, source)
        end
      end

      def map_custom_entity_attribute(attribute_name, source)
        data_class_name, data_field_name = source.split('#')

        @repository.data_mapping[data_class_name] ||= {}
        @repository.data_mapping[data_class_name][data_field_name.to_sym] = attribute_name
      end
    end
  end
end

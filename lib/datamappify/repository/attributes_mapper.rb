require 'datamappify/repository/attribute_source_data_class_builder'

module Datamappify
  module Repository
    class AttributesMapper
      def initialize(repository)
        @repository = repository

        map_non_custom_entity_attributes
        map_custom_entity_attributes
      end

      def build_data_classes
        @repository.data_mapping.each do |provider_class_name, data_class_mapping|
          data_class_mapping.each do |data_class_name, data_fields_mapping|
            AttributeSourceDataClassBuilder.new(provider_class_name, data_class_name).build(data_fields_mapping)
          end
        end
      end

      private

      def map_non_custom_entity_attributes
        provider_name   = @repository.default_provider_class_name
        data_class_name = @repository.entity_class.name

        @repository.data_mapping[provider_name] ||= {}
        @repository.data_mapping[provider_name][data_class_name] ||= MappingHash.new

        non_custom_attributes.each do |attribute_name|
          @repository.data_mapping[provider_name][data_class_name][attribute_name] = attribute_name
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
        namespaced_data_class_name, data_field_name = source.split('#')
        provider_name, data_class_name = namespaced_data_class_name.split('::')

        @repository.data_mapping[provider_name] ||= {}
        @repository.data_mapping[provider_name][data_class_name] ||= MappingHash.new
        @repository.data_mapping[provider_name][data_class_name][data_field_name.to_sym] = attribute_name
      end
    end
  end
end

require 'set'
require 'datamappify/data/mapper/attribute'

module Datamappify
  module Data
    class Mapper
      attr_accessor :entity_class
      attr_accessor :default_provider_name
      attr_accessor :custom_mapping

      def initialize
        @custom_mapping         = {}
        @custom_attribute_names = []
      end

      def default_provider
        @default_provider ||= Provider.const_get(default_provider_name)
      end

      def provider(provider_name)
        Provider.const_get(provider_name)
      end

      def default_source_class
        @default_source_class ||= default_provider.find_or_build_record(entity_class.name)
      end

      def classified_attributes
        @classified_attributes ||= Set.new(custom_attributes + default_attributes).classify(&:provider_name)
      end

      private

      def all_attribute_names
        entity_class.attribute_set.entries.collect(&:name)
      end

      def default_attribute_names
        all_attribute_names - custom_attribute_names
      end

      def custom_attribute_names
        # make sure custom attributes are always processed
        custom_attributes

        @custom_attribute_names
      end

      def default_attributes
        @default_attributes ||= default_attribute_names.collect do |attribute|
          Attribute.new(attribute, default_source_for(attribute))
        end
      end

      def custom_attributes
        @custom_attributes ||= custom_mapping.collect do |attribute, source|
          map_attribute(attribute, source)
        end
      end

      def map_attribute(attribute, source)
        @custom_attribute_names << attribute

        Attribute.new(attribute, source)
      end

      def default_source_for(attribute)
        "#{default_provider_name}::#{entity_class.name}##{attribute}"
      end
    end
  end
end

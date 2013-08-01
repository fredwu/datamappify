require 'set'
require 'datamappify/data/mapper/attribute'

module Datamappify
  module Data
    class Mapper
      # @return [Class]
      attr_accessor :entity_class

      # @return [String]
      attr_accessor :default_provider_name

      # @return [String]
      attr_writer :default_source_class_name

      # @return [Hash]
      #   attribute name to source mapping as specified in {Repository::MappingDSL#map_attribute}
      attr_accessor :custom_mapping

      # @return [Hash]
      attr_accessor :references

      def initialize
        @custom_mapping         = {}
        @custom_attribute_names = []
        @references             = {}

        @default_provider_name  = Datamappify.defaults.default_provider
      end

      # @return [Module]
      def default_provider
        @default_provider ||= Provider.const_get(default_provider_name)
      end

      # @param provider_name [String]
      #
      # @return [Module]
      def provider(provider_name)
        Provider.const_get(provider_name)
      end

      # @return [Class]
      def default_source_class
        @default_source_class ||= default_provider.find_or_build_record_class(default_source_class_name)
      end

      # @return [String]
      def default_source_class_name
        @default_source_class_name ||= entity_class.name
      end

      # @return [Set<Attribute>]
      def attributes
        @attributes ||= Set.new(default_attributes + custom_attributes)
      end

      # @return [Hash<Set>]
      #   attribute sets classified by the names of their data provider
      def classified_attributes
        @classified_attributes ||= Set.new(attributes).classify(&:provider_name)
      end

      private

      # @return [Array<Symbol>]
      def all_attribute_names
        entity_class.attribute_set.entries.collect(&:name)
      end

      # @return [Array<Symbol>]
      def default_attribute_names
        all_attribute_names - custom_attribute_names - reference_names
      end

      # @return [Array<Symbol>]
      def custom_attribute_names
        # make sure custom attributes are always processed
        custom_attributes

        @custom_attribute_names
      end

      # @return [Array<Symbol>]
      def reference_names
        references.keys
      end

      # @return [Array<Attribute>]
      def default_attributes
        @default_attributes ||= default_attribute_names.collect do |attribute|
          Attribute.new(
            attribute,
            :to                   => default_source_for(attribute),
            :provider             => default_provider_name,
            :primary_source_class => default_source_class
          )
        end
      end

      # @return [Array<Attribute>]
      def custom_attributes
        @custom_attributes ||= custom_mapping.collect do |attribute, options|
          map_custom_attribute(attribute, options)
        end
      end

      # @param (see Data::Mapper::Attribute#initialize)
      #
      # @return [Attribute]
      def map_custom_attribute(name, options)
        @custom_attribute_names << name

        options.reverse_merge!(:provider => default_provider_name)
        options.merge!(:primary_source_class => default_source_class)

        Attribute.new(name, options)
      end

      # @param attribute [Symbol]
      #   name of the attribute
      #
      # @return [String]
      def default_source_for(attribute)
        "#{default_source_class_name}##{attribute}"
      end
    end
  end
end

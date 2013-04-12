module Datamappify
  module Data
    class Mapper
      # Represents an entity attribute and its associated data source
      class Attribute
        # @return [String]
        attr_reader :name

        # @return [String]
        attr_reader :provider_name

        # @return [String]
        attr_reader :source_class_name

        # @return [String]
        attr_reader :source_attribute_name

        # @param name [Symbol]
        #   name of the attribute
        #
        # @param source [String]
        #   data provider, class and attribute,
        #   e.g. "ActiveRecord::User#surname"
        def initialize(name, source)
          @name = name.to_s

          @provider_name, @source_class_name, @source_attribute_name = parse_source(source)
        end

        # @return [Class]
        def source_class
          @source_class ||= Record.find_or_build(provider_name, source_class_name)
        end

        # @return [Boolean]
        def primary_key?
          source_attribute_name == 'id'
        end

        private

        # @return [Array<String>]
        #   an array with provider name, source class name and source attribute name
        def parse_source(source)
          provider_name, source_class_and_attribute = source.split('::')

          [provider_name, *source_class_and_attribute.split('#')]
        end
      end
    end
  end
end

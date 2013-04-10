module Datamappify
  module Data
    class Mapper
      class Attribute
        attr_reader :name, :provider_name, :source_class_name, :source_attribute_name

        def initialize(name, source)
          @name = name.to_s

          @provider_name, @source_class_name, @source_attribute_name = parse_source(source)
        end

        def source_class
          @source_class ||= Record.find_or_build(provider_name, source_class_name)
        end

        def primary_key?
          source_attribute_name == 'id'
        end

        private

        def parse_source(source)
          provider_name, source_class_and_attribute = source.split('::')

          [provider_name, *source_class_and_attribute.split('#')]
        end
      end
    end
  end
end

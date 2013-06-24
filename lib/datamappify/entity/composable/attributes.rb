module Datamappify
  module Entity
    module Composable
      class Attributes
        class << self
          def build(entity, entity_class, options)
            @entity       = entity
            @entity_class = entity_class
            @options      = options

            build_attributes
          end

          private

          # @return (see #attributes_from)
          def build_attributes
            @entity_class.attribute_set.each do |attribute|
              unless excluded_attributes.include?(attribute.name)
                @entity.attribute_set << build_attribute(attribute.name, attribute.writer)
              end
            end
          end

          # @return [Array]
          def excluded_attributes
            @excluded_attributes ||= @entity_class.reference_keys << :id
          end

          # @param attribute_name [Symbol]
          #
          # @param attribute_writer [Virtus::Attribute::Writer]
          #
          # @return [Virtus::Attribute]
          def build_attribute(attribute_name, attribute_writer)
            name = if @options[:prefix_with]
              Attribute.prefix(attribute_name, @options[:prefix_with])
            else
              attribute_name
            end

            Virtus::Attribute.build(
              name,
              attribute_writer.primitive,
              :default    => attribute_writer.default_value,
              :visibility => attribute_writer.visibility,
              :coercer    => attribute_writer.coercer
            )
          end
        end
      end
    end
  end
end

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
                @entity.attribute_set << build_attribute(attribute)
              end
            end
          end

          # @return [Array]
          def excluded_attributes
            @excluded_attributes ||= @entity_class.reference_keys + [:id, *@entity_class::IGNORED_ATTRIBUTE_NAMES]
          end

          # @param attribute [Virtus::Attribute]
          #
          # @return [Virtus::Attribute]
          def build_attribute(attribute)
            attribute_name = if @options[:prefix_with]
              Attribute.prefix(attribute.name, @options[:prefix_with])
            else
              attribute.name
            end

            attribute.rename(attribute_name)
          end
        end
      end
    end
  end
end
